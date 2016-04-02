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
          size: 10,
          address: {
            street: 'lorem'
          }
        }
      }
    }
  end

  let(:event) do
    create(:event, event_trigger: event_trigger, metadata: e_metadata)
  end

  let(:mail_action) do
    create(:event_trigger_mail_action, event_trigger: event_trigger, step: 1)
  end

  let(:mail_action_2) do
    create(
      :event_trigger_mail_action,
      event_trigger: event_trigger, step: 2
    )
  end

  let(:mail_action_3) do
    create(
      :event_trigger_mail_action,
      event_trigger: event_trigger, step: 3
    )
  end

  let(:cond_1) do
    create(
      :mail_action_condition,
      json_path: 'body_data.user.size',
      cond_op: 'eq',
      match_value: '10',
      event_trigger_mail_action_id: mail_action_2.id)
  end

  let(:cond_2) do
    create(
      :mail_action_condition,
      json_path: 'body_data.user.size',
      cond_op: 'gt_that',
      match_value: '9',
      event_trigger_mail_action_id: mail_action_3.id)
  end

  let(:event_trigger) { create(:event_trigger) }
  let!(:total_steps) { 3 }
  let!(:total_not_satisfy_cond) { 1 }

  before do
    mail_action
    mail_action_2
    mail_action_3
    cond_1
    cond_2
  end

  it 'should process over all steps o queue' do
    expect(event.executed_actions).to be_empty
    expect(ActionMailer::Base.deliveries).to be_empty
    expect(MailActionNotifier).to receive(
      :deliver).at_least(total_steps - total_not_satisfy_cond).times.and_call_original
    expect(EventsProcessJob).to receive(
      :perform_later).at_least(total_steps + 1).times.and_call_original

    perform_enqueued_jobs do
      EventsProcessJob.perform_later(event.id)
    end
    assert_performed_jobs total_steps + 1

    expect(event.executed_actions.only_ok.size).to eq(
      total_steps - total_not_satisfy_cond)
    expect(event.executed_actions.reload.size).to eq(total_steps)

    expect(ActionMailer::Base.deliveries.size).to eq(
      total_steps - total_not_satisfy_cond)

    email = ActionMailer::Base.deliveries.last
    expect(email.to).to eq([e_metadata[:to]])
    expect(email.from).to eq([e_metadata[:from]])
    expect(email.reply_to).to eq([e_metadata[:reply_to]])
    expect(email.subject.to_s).to eq('welcome foo bar')
    expect(email.body.to_s).to eq('hello foo bar body of street lorem')
  end
end
