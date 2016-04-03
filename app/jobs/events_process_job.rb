# EventsProcessJob process all actions that event_triggers is related
class EventsProcessJob < ActiveJob::Base
  queue_as :default

  def perform(event_id)
    e = Event.find event_id
    last_exec_date = e.last_cond_ok_exec_action.try(:created_at) || e.created_at
    step = e.next_step

    if step
      should_exec_at = last_exec_date + step.exec_after.minutes

      if DateTime.now > should_exec_at
        unless e.executed_actions.where(
          event_trigger_mail_action_id: step.id).exists?

          ex_action = e.executed_actions.new(event_trigger_mail_action: step)

          if step.action_condition.present?
            ex_action.cond = step.action_condition.attributes
            ex_action.cond_ok = step.action_condition.data_satisfy?(e.metadata)
          end

          ex_action.save!

          MailActionNotifier.deliver(ex_action, step).deliver_now if ex_action.cond_ok
          EventsProcessJob.perform_later(e.id)
        end
      else
        EventsProcessJob.set(
          wait_until: (should_exec_at + 1.second)).perform_later(e.id)
      end
    end
  end
end
