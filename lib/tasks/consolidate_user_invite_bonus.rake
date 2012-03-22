namespace :invite_bonus do
  desc "Consolidate all users invite bonus in credits table (do not run this task twice!)"
  task :consolidate => :environment do
    File.open(Rails.root + "log/users_with_more_than_50_of_invite_bonus.log", "w") do |log|
      log.puts "user_id;email;name;invites;invite_bonus;used_invite_bonus;"
      User.find_each do |u|
        invite_bonus = u.invite_bonus
        if invite_bonus > 0
          if invite_bonus >= 50
            log.puts "#{u.id};#{u.email};#{u.name};#{u.invites.count};#{invite_bonus};#{u.used_invite_bonus};"
          else
            u.credits.create!( :value => invite_bonus, :total => invite_bonus, :source => "invite_bonus", :multiplier => 1)
          end
        end
      end
    end
  end

  desc "Consolidate invite bonus for a specific user (receives an user email as argument)"
  task :consolidate_for_user, [:email] => :environment do |t, args|
    user = User.find_by_email!(args[:email])
    if user
      puts "-------------------------------------------------------"
      puts "Consolidating credits for #{user.name} (id: #{user.id})"
      puts "This user has been marked with the fraud flag." if user.has_fraud?
      puts "This user has #{user.invites.accepted.count} accepted invites."
      puts "User credits before consolidation: #{user.current_credit}"

      invite_bonus = user.invite_bonus
      used_invite_bonus = user.used_invite_bonus
      earned_invite_bonus = invite_bonus + used_invite_bonus
      new_mgm_invitee_bonus = user.credits.where(:source => "invitee_bonus").sum(:value)

      puts "User spent invite bonus          : #{used_invite_bonus}"
      puts "User earned invite bonus         : #{earned_invite_bonus}"
      puts "User bonus from new MGM          : #{new_mgm_invitee_bonus}"

      if invite_bonus > 0
        credits_after_consolidation = invite_bonus + new_mgm_invitee_bonus
        credit = user.credits.create!(:value => credits_after_consolidation,
                            :total => credits_after_consolidation,
                            :source => "consolidate_invite_bonus",
                            :multiplier => 1)
        puts "User credit was consolidated. If you want to revert this action, destroy the credit with id equal to #{credit.id}"
      else
        "Can't consolidate this user invite bonus credit. The value is negative."
      end
      puts "User credits after consolidation : #{user.current_credit}"
    end
  end
end