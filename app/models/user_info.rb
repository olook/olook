class UserInfo < ActiveRecord::Base
	belongs_to :user

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
