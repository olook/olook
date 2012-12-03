# == Schema Information
#
# Table name: user_infos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  shoes_size :integer
#  created_at :datetime
#  updated_at :datetime
#

class UserInfo < ActiveRecord::Base
	belongs_to :user

    attr_accessible :shoes_size

	SHOES_SIZE =
  {
    "223" => '33',
    "211" => '34',
    "212" => '35',
    "213" => '36',
    "214" => '37',
    "215" => '38',
    "216" => '39',
    "217" => '40',
  }
end
