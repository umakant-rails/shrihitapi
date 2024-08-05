class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.email
  layout "mailer"
end
