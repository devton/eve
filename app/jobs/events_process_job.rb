# EventsProcessJob process all actions that event_triggers is related
class EventsProcessJob < ActiveJob::Base
  queue_as :default

  def perform(event_id)
    e = Event.find event_id
    e.event_trigger.mail_actions.each do |m|
      e.executed_actions.create(
        event_trigger_mail_action: m)
    end
  end
end
