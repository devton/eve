require 'rails_helper'

RSpec.describe EventsProcessJob, type: :job do
  let(:e_metadata) do
    {
      trigger_name: event_trigger.trigger_name,
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
  let(:event) { create(
    :event, event_trigger: event_trigger, metadata: e_metadata) }
  let(:mail_action) { create(
    :event_trigger_mail_action, event_trigger: event_trigger, step: 1)}
  let(:mail_action_2) { create(
    :event_trigger_mail_action, event_trigger: event_trigger, step: 2)}

  before do
    mail_action
  end

  it 'should process over all steps o queue' do
    expect(event.executed_actions).to be_empty
    expect(ActionMailer::Base.deliveries).to be_empty
    expect(MailActionNotifier).to receive(
      :deliver).and_call_original
    expect(EventsProcessJob).to receive(
      :perform_later).at_least(2).times.and_call_original

    perform_enqueued_jobs do
      EventsProcessJob.perform_later(event.id)
    end
    assert_performed_jobs 2

    expect(ActionMailer::Base.deliveries).not_to be_empty

    email = ActionMailer::Base.deliveries.last
    expect(email.to).to eq([e_metadata[:to]])
    expect(email.from).to eq([e_metadata[:from]])
    expect(email.reply_to).to eq([e_metadata[:reply_to]])
    expect(email.subject.to_s).to eq('welcome foo bar')
    expect(email.body.to_s).to eq('hello foo bar body of street lorem')
    expect(event.executed_actions.reload).not_to be_empty
  end
end
