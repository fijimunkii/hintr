# == Schema Information
#
# Table name: matches
#
#  id         :integer          not null, primary key
#  like_id    :integer
#  user_id    :integer
#  hint_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Match < ActiveRecord::Base
  attr_accessible :like_id, :user_id, :hint_id

  belongs_to :like
  belongs_to :user
  belongs_to :hint

end
