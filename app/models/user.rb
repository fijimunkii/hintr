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

  def scrape_facebook

    user = facebook { |fb| fb.get_object('me', :fields => 'name,gender,relationship_status,interested_in,birthday,location,email') }

    friends = facebook { |fb| fb.get_connections(user['id'], 'friends') }
    self.num_friends = friends.size
    self.friends_processed = 0

    friends.each_with_index do |friend, index|

      #break if index == 20

      friend_object = facebook { |fb| fb.get_object(friend['id'], :fields => 'name,gender,relationship_status,interested_in,birthday,location') }
      if friend_object['gender'] == self.interested_in #TODO make this work for 'both'

        #find the new_user or create a new one
        User.where(fb_id: friend['id']).first_or_initialize.tap do |new_user|
          if friend_object['location']
            new_user.location = friend_object['location']['name'] if friend_object['location']['name']
          end
          new_user.fb_id = friend_object['id']
          new_user.name = friend_object['name']
          new_user.relationship_status = friend_object['relationship_status'] if friend_object['relationship_status']
          new_user.date_of_birth = friend_object['birthday'] if friend_object['birthday']
          new_user.gender = friend_object['gender'] if friend_object['gender']
          new_user.profile_picture = facebook { |fb| fb.get_picture(new_user.fb_id, { :width => 720, :height => 720 }) }
          new_user.save!

          photos = facebook { |fb| fb.get_connections(friend_object['id'],"albums", :fields => "name, photos.fields(source, likes.summary(true))") }
          photos_by_number = {}
          if photos[0] && photos[0]['photos'] && photos[0]['photos']['data']
            photos[0]['photos']['data'].each do |x|
              if x['likes']
                photos_by_number[x['likes']['summary']['total_count']] = x['source']
              else
                photos_by_number['0'] = x['source']
              end
            end
          end

          sorted_photos = photos_by_number.sort_by { |x, y| x.to_i }.reverse
          sorted_photos.each do |x|
            Picture.create(user_id: new_user.id, url: x[1])
          end

          Match.where(user_id: self.id, related_user_id: new_user.id).first_or_initialize.tap do |match|
            match.user_id = self.id
            match.related_user_id = new_user.id
            match.relationship_status = new_user.relationship_status
            match.location = new_user.location if new_user.location
            match.name = new_user.name
            match.profile_picture = new_user.profile_picture
            likes = facebook { |fb| fb.fql_query("SELECT page_id, type FROM page_fan WHERE uid= #{self.fb_id} AND page_id IN (SELECT page_id FROM page_fan WHERE uid = #{new_user.fb_id})") }
            match.weight = likes.length
            match.save!

            if self.max_weight < match.weight
              self.max_weight = match.weight
              self.save
            end

            likes.each do |like|
              Like.where(match_id: match.id, fb_id: like['page_id'].to_s).first_or_initialize.tap do |new_like|
                new_like.match_id = match.id
                new_like.fb_id = like['page_id']
                new_like.like_type = like['type']
                new_like.save!
              end
            end

          end # match

        end # New User

      end #if gender

      self.friends_processed += 1
      self.save

    end # friends.each

    self.watched_intro = true
    self.save

    # send email that profile is set up
    Resque.enqueue(RegistrationMailer, self.id)
  end

end
