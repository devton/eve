require 'rails_helper'

RSpec.describe EventsProcessJob, type: :job do
  let(:event) { create(:event) }
  let(:mail_action) { create(:event_trigger_mail_action, event_trigger: event.event_trigger)}

  before do
    mail_action
  end

  it do
    expect(event.executed_actions).to be_empty

    assert_performed_with(
      job: EventsProcessJob,
      args: [event.id],
      queue: 'default'
    ) do
      EventsProcessJob.perform_later(event.id)
    end
    expect(event.executed_actions.reload).not_to be_empty
  end
end
