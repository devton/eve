FactoryGirl.define do
  factory :event do
    event_trigger
    metadata do
      {
        event_trigger: 'trigger',
        to: 'example@email.com',
        from: 'system@example.com',
        reply_to: 'lorem@lorem.com',
        subject_data: {
          user: {
            name: 'Foo name'
          }
        },
        body_data: {
          user: {
            name: 'Foo name'
          }
        }
      }.to_json
    end
  end

end
