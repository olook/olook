# -*- encoding : utf-8 -*-
superadmin = Role.where(:name => "superadministrator").first_or_create(:description => "Manages the whole system")

Admin.where(:email => "admin@olook.com").first_or_create( :password =>"DifficultPassword123",
																										    :first_name => "administrator",
																										    :last_name => "olook",
																										    :role => superadmin)

SurveyBuilder.new( SURVEY_DATA, "Registration Survey" ).build

{ "Sexy" => "sexy", 
	"Elegante" => "chic", 
	"Básica" => "casual", 
	"Fashionista" => "moderna" }.each do |key, value|
		Profile.find_by_name(key).update_attribute(:alternative_name, value)
end

