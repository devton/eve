require 'rails_helper'

RSpec.describe EventTrigger, type: :model do
  let(:event_trigger) { create(:event_trigger) }

  describe 'validatios' do
    before { event_trigger }

    it { should validate_presence_of(:trigger_name) }
    it { should validate_presence_of(:description) }
    it { should validate_uniqueness_of(:trigger_name) }
    it { should have_many(:mail_actions) }

    it do
      should allow_values(
        'trigger_name', 'trname', 'tr_name_431'
      ).for(:trigger_name)
    end

    it do
      should_not allow_value(
        'tRiggernAme', 'TR_NAME', 'Tr Name'
      ).for(:trigger_name)
    end
  end
end
