FactoryGirl.define do
  factory :event_trigger_mail_action do
    event_trigger
    mail_message
    sequence(:step) { |n| n }
    exec_after 0
  end
end
