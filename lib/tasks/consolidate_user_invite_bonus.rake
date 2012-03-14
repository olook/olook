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
end