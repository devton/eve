FactoryGirl.define do
  factory :event_trigger do
    sequence(:trigger_name) { |n|  "my_trigger_name_#{n}" }
    description "MyText"
    enabled true
  end

end
