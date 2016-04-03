class SendgridProcessor
  def call(event)
    SendgridEvent.create!(
      event_executed_action_id: event.attributes['event_executed_action_id'].to_i,
      event: event.attributes['event'],
      email: event.attributes['email'],
      useragent: event.attributes['useragent'],
      sendgrid_data: event.attributes
    )
  end
end
