require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { create(:event) }

  describe 'validations' do
    before { event }

    it { should validate_presence_of(:event_name) }
    it { should validate_presence_of(:session_id) }
    it { should validate_presence_of(:metadata) }
    it { should belong_to(:event_trigger) }
    it { should have_many(:executed_actions) }

    it do
      should allow_value({
        event_name: 'foo_bar',
        session_id: 'AbCD',
        email: 'example@example.com'
      }).for(:metadata)
    end

    it do
      should_not allow_value({
        trigger_name: 'foo_bar'
      }, {}, {email: 'foo@foo.com'}).for(:metadata)
    end
  end

  describe 'steps' do
    let(:event_trigger) { event.event_trigger }
    before do
      3.times do |i|
        create(
          :event_trigger_mail_action,
          event_trigger: event_trigger,
          step: i
        )
      end
    end

    let(:fs) do
      -> (x) { event_trigger.mail_actions.find_by_step(x) }
    end

    context '.step_actions' do
      it 'should return asc ordered steps' do
        expect(event.step_actions[0].step).to eq(0)
        expect(event.step_actions[1].step).to eq(1)
        expect(event.step_actions[2].step).to eq(2)
      end
    end

    context '.next_step' do
      it 'should return first step on first time' do
        expect(event.next_step).to eq(event_trigger
          .mail_actions.find_by_step(0))
      end

      it 'should return second step after' do
        create(
          :event_executed_action,
          event: event, event_trigger_mail_action: fs.call(0))
        expect(event.next_step).to eq(fs.call(1))
      end

      it 'should return third step after' do
        create(
          :event_executed_action,
          event: event, event_trigger_mail_action: fs.call(1))
        expect(event.next_step).to eq(fs.call(2))
      end

      it 'should return nil when executed all steps' do
        create(
          :event_executed_action,
          event: event, event_trigger_mail_action: fs.call(2))
        expect(event.next_step).to eq(nil)
      end
    end
  end
end
