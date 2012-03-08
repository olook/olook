namespace :consolidate_user_invite_bonus do
  desc "Consolidate all users invite bonus in credits table (do not run this task twice!)"
  task :execute => :environment do
    User.find_each do |u|
      invite_bonus = u.invite_bonus
      if invite_bonus > 0
        u.credits.create!( :value => invite_bonus, :total => invite_bonus, :source => "invite_bonus", :multiplier => 1)
      end
    end
  end
end