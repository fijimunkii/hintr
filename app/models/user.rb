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

  # creates the User from info received back from facebook authentication
  def self.from_omniauth(auth)

    # if the user already exists, update
    # if user does not exist, create
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|

      # initial pull from facebook
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

  def scrape_facebook

    binding.pry

    user = self.facebook.get_object('me')
    friends = graph.get_connections(user['id'], 'friends')
    friends.each do |friend|

      binding.pry

      self.facebook.batch do |batch_api|

        binding.pry

        hint = Hint.new
        hint.id = friend['id']
        hint.name = friend['name']
        hint.profile_picture = batch_api.get_picture(hint.id)
        hint.save
      end
    end

  end

end
