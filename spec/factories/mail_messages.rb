FactoryGirl.define do
  factory :mail_message do
    sequence(:label ) { |x| "label_#{x}" }
    subject "My subject text"
    body "Mybody message"
  end
end
