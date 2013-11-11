# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  provider         :string(255)
#  uid              :string(255)
#  name             :string(255)
#  oauth_token      :string(255)
#  oauth_expires_at :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  image            :string(255)
#  location         :string(255)
#

class User < ActiveRecord::Base

  attr_accessible :provider, :uid, :name, :oauth_token, :oauth_expires_at, :image, :location

  has_many :hints
  has_many :matches
  has_many :likes, :through => :matches

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
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|

      # initial pull from facebook
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = new_access_token #originally auth.credentials.token
      user.oauth_expires_at = new_access_expires_at #originally Time.at(auth.credentials.expires_at)
      user.image = auth.info.image
      user.location = auth.info.location
      user.save!
    end
  end

  def facebook
    # creates a facebook variable that can be used
    # for interacting with the users info on facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
  end

  def scrape_facebook

    user = self.facebook.get_object('me')
    self.location = user['location']['name']
    self.save! #TODO get interested_in

    friends = self.facebook.get_connections(user['id'], 'friends')
    friends.each do |friend|

      hint_object = self.facebook.get_object(friend['id']) #objectify.. in a good way
      if hint_object['gender'] == 'female' #TODO make this reference self.interested_in

        #find the hint or create a new one
        Hint.where(user_id: self.id, fb_id: friend['id']).first_or_initialize.tap do |hint|
          hint.user_id = self.id
          hint.fb_id = hint_object['id']
          hint.name = hint_object['name']
          hint.location = hint_object['location']['name']
          hint.gender = hint_object['gender']
          hint.profile_picture = self.facebook.get_picture(hint.fb_id, { :width => 720, :height => 720 })
          hint.save!

          likes = self.facebook.get_connections(hint_object['id'], 'likes')
          likes.each do |like|
            Like.where(fb_id: like['id']).first_or_initialize.tap do |update_like|
              update_like.fb_id = like['id']
              update_like.name = like['name']
              update_like.save!

              Match.where(hint_id: hint.id, like_id: update_like.id).first_or_initialize.tap do |update_match|
                update_match.like_id = update_like.id
                update_match.hint_id = hint.id
                update_match.save!
              end #Match
            end #Like
          end #likes.each
        end # Hint
      end #if gender

    end # friends.each

  end

end
