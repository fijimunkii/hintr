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
#  watched_intro       :boolean
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
    where(auth.slice(:provider, :fb_id)).first_or_initialize.tap do |user|

      # initial pull from facebook
      user.provider = auth.provider
      user.fb_id = auth.uid
      user.name = auth.info.name
      user.oauth_token = new_access_token #originally auth.credentials.token
      user.oauth_expires_at = new_access_expires_at #originally Time.at(auth.credentials.expires_at)
      user.profile_picture = auth.info.image
      user.location = auth.info.location
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

  #TODO Thin Parallel threads

  def scrape_facebook

    user = facebook { |fb| fb.get_object('me', :fields => 'name,gender,relationship_status,interested_in,birthday,location,email') }
    if user['location']
      self.location = user['location']['name'] if user['location']['name']
    end
    self.email = user['email'] if user['email']
    self.relationship_status = user['relationship_status'] if user['relationship_status']
    self.date_of_birth = user['birthday'] if user['birthday']
    self.save!

    friends = facebook { |fb| fb.get_connections(user['id'], 'friends') }
    friends.each_with_index do |friend, index|

      #break if index == 20 #only processing the first 20

      friend_object = facebook { |fb| fb.get_object(friend['id'], :fields => 'name,gender,relationship_status,interested_in,birthday,location') }
      if friend_object['gender'] == 'female' #TODO make this reference self.interested_in

        #find the hint or create a new one
        User.where(fb_id: friend['id']).first_or_initialize.tap do |hint|
          if friend_object['location']
            hint.location = friend_object['location']['name'] if friend_object['location']['name']
          end
          hint.fb_id = friend_object['id']
          hint.name = friend_object['name']
          hint.relationship_status = friend_object['relationship_status'] if friend_object['relationship_status']
          hint.date_of_birth = friend_object['birthday'] if friend_object['birthday']
          hint.gender = friend_object['gender'] if friend_object['gender']
          hint.profile_picture = facebook { |fb| fb.get_picture(hint.fb_id, { :width => 720, :height => 720 }) }
          hint.save!

          Match.where(user_id: self.id, related_user_id: hint.id).first_or_initialize.tap do |match|
            match.user_id = self.id
            match.related_user_id = hint.id
            match.name = hint.name
            match.profile_picture = hint.profile_picture
            likes = facebook { |fb| fb.fql_query("SELECT page_id, type FROM page_fan WHERE uid= #{self.fb_id} AND page_id IN (SELECT page_id FROM page_fan WHERE uid = #{hint.fb_id})") }
            match.weight = likes.length
            match.save!

            likes.each do |like|
              Like.where(match_id: match.id, fb_id: like['page_id'].to_s).first_or_initialize.tap do |new_like|
                new_like.match_id = match.id
                new_like.fb_id = like['page_id']
                new_like.like_type = like['type']
                new_like.save!
              end
            end

          end # match

        end # Hint

        num_friends += 1


        CUSTOM_LOGGER.info("Added new hint - #{num_friends/friends}% Complete")

      end #if gender

    end # friends.each

  end

end
