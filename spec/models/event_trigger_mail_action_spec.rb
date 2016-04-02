require 'rails_helper'

RSpec.describe EventTriggerMailAction, type: :model do
  let(:mail_action) { create(:event_trigger_mail_action) }

  describe 'validations' do
    before { mail_action }

    it { should validate_presence_of(:event_trigger) }
    it { should validate_presence_of(:mail_message) }
    it { should validate_uniqueness_of(:step).scoped_to(:event_trigger_id) }
    it { should belong_to(:event_trigger) }
    it { should belong_to(:mail_message) }
  end
end
