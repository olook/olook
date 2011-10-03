class InvitesMailer < ActionMailer::Base
  include Resque::Mailer

  default from: "no-reply@olook.com.br"

  def invite_email(user, email, invitation_code)
    @user = user
    @invitation_code = invitation_code

    mail :to => email, :subject => "#{@user.name} wants you to join Olook!"
  end

end
