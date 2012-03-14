# -*- encoding : utf-8 -*-
require 'csv'

namespace :invalid_invites do
  desc "Destroy all invites from users with fake CPF and mark the inviters with fraud flag"
  task :destroy => :environment do
    File.open(Rails.root + "log/destroy_invalid_invites.log", "w") do |log|
      log.puts "cpf;\tInviteeEmail;\tInviteeUserId;\tInviteId;\tAcceptedAt;\tInviterEmail\t;InviterId;"
      destroyed = 0
      frauds = 0
      CSV.foreach(Rails.root + "lib/tasks/invalid_cpf_list.csv") do |cpf|
        cpf = cpf.first
        log.write "#{cpf};\t"
        invitee = User.where(:cpf => cpf).first
        if invitee
          log.write "#{invitee.email};\t #{invitee.id};\t"
          invite = Invite.where(:invited_member_id => invitee.id).first
          if invite
            log.write "#{invite.id};\t"
            inviter = invite.user
            if inviter
              log.write "#{inviter.email};\t#{inviter.id};\t"
              unless inviter.has_fraud?
                inviter.update_attribute(:has_fraud, true)
                frauds += 1
              end
            end
            invite.destroy
            destroyed += 1
          end
        end
        log.write "\n"
      end
    end
  end
end