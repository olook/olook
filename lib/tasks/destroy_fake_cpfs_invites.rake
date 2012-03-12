# -*- encoding : utf-8 -*-
require 'csv'

namespace :destroy_invalid_invites do
  desc "Destroy all invites from users with fake CPF and mark the inviters with fraud flag"
  task :execute => :environment do
    CSV.foreach(Rails.root + "lib/tasks/invalid_cpf_list.csv") do |cpf|
      invitee_email = User.where(:cpf => cpf).select(:email).first.try(:email)
      if invitee_email
        invite = Invite.where(:email => invitee_email).first
        if invite
          invite.user.update_attribute(:has_fraud, true)
          invite.destroy
        end
      end
    end
  end
end