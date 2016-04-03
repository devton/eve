FactoryGirl.define do
  factory :sendgrid_event do
    event_executed_action
    event "MyText"
    email "MyText"
    useragent "MyText"
  end

end
