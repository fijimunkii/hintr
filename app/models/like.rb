# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  match_id   :integer
#  fb_id      :string(255)
#  type       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Like < ActiveRecord::Base
  attr_accessible :match_id, :fb_id, :name

  belongs_to :match

end
