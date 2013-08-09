class UserInfo < ActiveRecord::Base
	belongs_to :user

    attr_accessible :shoes_size, :dress_size, :t_shirt_size, :pants_size, :state, :city

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
