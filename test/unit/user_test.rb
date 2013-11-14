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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
