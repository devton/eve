FactoryGirl.define do
  factory :event_trigger_mail_action do
    event_trigger
    mail_message
  end
end
