require 'rails_helper'

RSpec.describe EventExecutedAction, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:event) }
    it { should validate_presence_of(:event_trigger_mail_action) }
    it { should belong_to(:event) }
    it { should belong_to(:event_trigger_mail_action) }
  end

  describe '#only_ok' do
    before do
      2.times { create(:event_executed_action)}
      4.times { create(:event_executed_action, metadata: { cond_ok: false }) }
    end

    it { expect(EventExecutedAction.only_ok.count).to eq(2) }
  end
end
