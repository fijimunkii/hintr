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
  has_many :likes

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
    friends = self.facebook.get_connections(user['id'], 'friends')
    friends.each do |friend|

      self.facebook.batch do |batch_api|
        hint_object = self.facebook.get_object(friend['id']) #objectify.. in a good way
        if hint_object['gender'] == female #TODO make this reference self.interested_in

          #find the hint or create a new one
          Hint.where(user_id: self.id, fb_id: friend['id']).first_or_initialize.tap do |hint|
            hint.user_id = self.id
            hint.fb_id = hint_object['id']
            hint.name = hint_object['name']
            hint.profile_picture = batch_api.get_picture(hint_object.id)
            hint.save!
          end

        end
      end

    end

  end

end
