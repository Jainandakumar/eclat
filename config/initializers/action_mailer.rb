# Rails 7.0 compatibility fix for ActionMailer::DeliveryJob
# The constant was renamed to ActionMailer::MailDeliveryJob
unless defined?(ActionMailer::DeliveryJob)
  ActionMailer::DeliveryJob = ActionMailer::MailDeliveryJob
end