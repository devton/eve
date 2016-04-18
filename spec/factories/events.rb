FactoryGirl.define do
  factory :event do
    event_trigger
    metadata do
      {
        event_name: 'trigger',
        email: 'example@email.com',
        session_id: 'XkDf',
        from: 'system@example.com',
        reply_to: 'lorem@lorem.com',
        data: {
          user: {
            name: 'Foo name'
          }
        }
      }
    end
  end

end
