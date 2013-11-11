# == Schema Information
#
# Table name: hints
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  fb_id               :integer
#  age                 :integer
#  name                :string(255)
#  gender              :string(255)
#  interested_in       :string(255)
#  relationship_status :string(255)
#  location            :string(255)
#  score               :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  profile_picture     :string(255)
#

class Hint < ActiveRecord::Base
  attr_accessible :user_id, :fb_id, :age, :name, :gender, :interested_in, :relationship_status, :location, :score, :profile_picture

  belongs_to :user
  has_many :pictures
  has_many :matches
  has_many :likes, :through => :matches
end
