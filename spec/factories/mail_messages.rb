FactoryGirl.define do
  factory :mail_message do
    sequence(:label ) { |x| "label_#{x}" }
    subject 'welcome {{user.name}}'
    body 'hello {{user.name}} of street {{user.address.street}}'
  end
end
