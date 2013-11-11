class User < ActiveRecord::Base

  # creates the User from info received back from facebook authentication
  def self.from_omniauth(auth)

    # if the user already exists, update
    # if user does not exist, create
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
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

end
