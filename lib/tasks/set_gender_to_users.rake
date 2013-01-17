namespace :gender do
  desc "Set gender as 0 (female) to all users with gender nil (only for half_users)"
  task set_gender_to_users: :environment do
    User.update_all("gender = 0", "half_user = 1 AND gender is null")
  end

end
