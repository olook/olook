namespace :gender do
  desc "Set gender as 0 (female) to all users with gender nil (only for half_users)"
  task set_gender_to_users: :environment do
    User.where("gender IS NULL AND half_user = 1").find_each do |user|
      user.update_attribute(:gender, 0)
    end
  end
end

