# == Schema Information
#
# Table name: matches
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  related_user_id :integer
#  weight          :integer
#  name            :string(255)
#  profile_picture :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Match < ActiveRecord::Base
  attr_accessible :user_id, :related_user_id, :weight, :name, :profile_picture

  belongs_to :user
  belongs_to :related_user, :class_name => "User"

  has_many :likes

end
