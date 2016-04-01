require 'rails_helper'

RSpec.describe EventsProcessJob, type: :job do
  let(:e_metadata) do
    {
      event_trigger: event_trigger.trigger_name,
      to: 'test@test.com',
      reply_to: 'r@test.com',
      from: 'f@test.com',
      subject_data: {
        user: {
          name: 'foo bar'
        }
      },
      body_data: {
        user: {
          name: 'foo bar body',
          address: {
            street: 'lorem'
          }
        }
      }
    }
  end

  let(:event_trigger) { create(:event_trigger) }
  let(:event) { create(:event, event_trigger: event_trigger, metadata: e_metadata) }
  let(:mail_action) { create(:event_trigger_mail_action, event_trigger: event_trigger)}

  before do
    mail_action
  end

  it do
    expect(event.executed_actions).to be_empty
    expect(ActionMailer::Base.deliveries).to be_empty

    assert_performed_with(
      job: EventsProcessJob,
      args: [event.id],
      queue: 'default'
    ) do
      EventsProcessJob.perform_later(event.id)
    end

    expect(ActionMailer::Base.deliveries).not_to be_empty

    email = ActionMailer::Base.deliveries.last
    expect(email.to).to eq([e_metadata[:to]])
    expect(email.from).to eq([e_metadata[:from]])
    expect(email.reply_to).to eq([e_metadata[:reply_to]])
    expect(email.subject.to_s).to eq("welcome foo bar")
    expect(email.body.to_s).to eq("hello foo bar body of street lorem")
    expect(event.executed_actions.reload).not_to be_empty
  end
end
