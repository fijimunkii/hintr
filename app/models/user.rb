# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  provider            :string(255)
#  fb_id               :string(255)
#  email               :string(255)
#  name                :string(255)
#  gender              :string(255)
#  interested_in       :string(255)
#  relationship_status :string(255)
#  location            :string(255)
#  profile_picture     :string(255)
#  date_of_birth       :date
#  oauth_token         :string(255)
#  oauth_expires_at    :datetime
#  watched_intro       :boolean          default(FALSE)
#  max_weight          :integer          default(0)
#  num_friends         :integer          default(0)
#  friends_processed   :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :provider, :uid, :name, :oauth_token, :oauth_expires_at, :image, :location

  has_many :pictures

  has_many :related_users_association, :class_name => "Match"
  has_many :related_users, :through => :related_users_association, :source => :related_user
  has_many :inverse_related_users_association, :class_name => "Match", :foreign_key => "related_user_id"
  has_many :inverse_related_users, :through => :inverse_related_users_association, :source => :user


  # creates the User from info received back from facebook authentication
  def self.from_omniauth(auth)

    # immediately get 60 day auth token
    # https://github.com/mkdynamic/omniauth-facebook/issues/23#issuecomment-15565902
    oauth = Koala::Facebook::OAuth.new(ENV["HINTR_FACEBOOK_KEY"], ENV["HINTR_FACEBOOK_SECRET"])
    new_access_info = oauth.exchange_access_token_info auth.credentials.token

    new_access_token = new_access_info["access_token"]
    new_access_expires_at = DateTime.now + new_access_info["expires"].to_i.seconds

    # if the user already exists, update
    # if user does not exist, create
    User.where(fb_id: auth.uid).first_or_initialize.tap do |user|

      # initial pull from facebook
      user.provider = auth.provider
      user.fb_id = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.oauth_token = new_access_token #originally auth.credentials.token
      user.oauth_expires_at = new_access_expires_at #originally Time.at(auth.credentials.expires_at)
      user.profile_picture = auth.info.image
      user.location = auth.info.location if auth.info.location
      user.relationship_status = auth.extra.raw_info.relationship_status if auth.extra.raw_info.relationship_status
      user.date_of_birth = auth.extra.raw_info.birthday if auth.extra.raw_info.birthday
      user.location = auth.extra.raw_info.location.name if auth.extra.raw_info.location
      user.save!

    end
  end




  def facebook
    # creates a facebook variable that can be used
    # for interacting with the users info on facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    block_given? ? yield(@facebook) : @facebook
    rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil
  end




  def process_friends

    # creates an array of the friends
    friends = facebook { |fb| fb.get_connections(self.fb_id, 'friends', :fields => 'gender') }

    # for each friend, enqueue update tasks
    friends.each_with_index do |friend, index|

      # filter gender preference
      if friend['gender'] == self.interested_in
        Resque.enqueue(FacebookScraper, self.id, friend['id'])
      # account for ["male, female"]
      elsif self.interested_in.length == 2
        Resque.enqueue(FacebookScraper, self.id, friend['id'])
      end

      # after queueing the last friend
      # send out email and let user into site
      if index == friends.length
        Resque.enqueue(RegistrationFinisher, self.id)
      end

    end

  end




  def fb_update_user(facebook_id)
    # get the friend object from facebook
    friend_response = facebook { |fb| fb.get_connections(self.fb_id, facebook_id) }

    # find or create the User matching the facebook ID
    friend = User.where(fb_id: friend_response['id']).first_or_initialize.tap do |user|

      # update properties on the user
      %w{name relationship_status birthday gender}.each do |prop|
        user[prop] = friend_response[prop] if friend_response[prop]
      end

    end

    friend.save

  end




  def fb_update_photos(facebook_id)

    # grab all photo albums of user
    photos = facebook { |fb| fb.get_connections(facebook_id,"albums", :fields => "name, photos.fields(source, likes.summary(true))") }
    photos_by_number = {}

    # check if profile pictures is accessible
    if photos[0] && photos[0]['photos'] && photos[0]['photos']['data']
      # process each profile picture
      photos[0]['photos']['data'].each do |photo|
        # if the picture has likes, add it to photos_by_number
        # with an index of the number of likes
        if photo['likes']
          photos_by_number[photo['likes']['summary']['total_count']] = photo['source']
        else
          photos_by_number['0'] = photo['source']
        end
      end
    end

    # sort the photos by number of likes
    sorted_photos = photos_by_number.sort_by { |x, y| x.to_i }.reverse

    # create a new Picture object for each photo
    sorted_photos.each do |photo|
      Picture.create(user_id: new_user.id, url: photo[1])
    end

  end




  def fb_update_match(facebook_id)
    # locate the user for the matchmaking process
    new_user = User.where(fb_id: facebook_id)

    # create or update the match
    Match.where(user_id: self.id, related_user_id: new_user.id).first_or_initialize.tap do |match|
      match.user_id = self.id
      match.related_user_id = new_user.id
      match.relationship_status = new_user.relationship_status
      match.location = new_user.location if new_user.location
      match.name = new_user.name
      match.profile_picture = new_user.profile_picture

      # ask facebook to do a join table on common likes
      # https://developers.facebook.com/docs/technical-guides/fql/
      likes = facebook { |fb| fb.fql_query("SELECT page_id, type FROM page_fan WHERE uid= #{self.fb_id} AND page_id IN (SELECT page_id FROM page_fan WHERE uid = #{new_user.fb_id})") }

      # save the number of likes in common
      match.weight = likes.length
      match.save!

      # update the current user's maximum compatibility
      if self.max_weight < match.weight
        self.max_weight = match.weight
        self.save
      end

      # create or update a Like object for each like in common
      likes.each do |like|
        Like.where(match_id: match.id, fb_id: like['page_id'].to_s).first_or_initialize.tap do |new_like|
          new_like.match_id = match.id
          new_like.fb_id = like['page_id']
          new_like.like_type = like['type']
          new_like.save!
        end
      end

    end # end of matchmaking process

  end


end
