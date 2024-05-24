class DeviseMailer < Devise::Mailer
  default from: 'brijras.team@donotreply'
  
  def confirmation_instructions(record, token, opts={})
    mail = super
    mail.subject = "Brijras.com Account Confirmation"
    mail
  end

  def reset_password_instructions(record, token, opts={})
    mail = super
    mail.subject = "Brijras.com Reset New Password"
    mail
  end

end