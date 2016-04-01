require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { create(:event) }

  describe 'validations' do
    before { event }

    it { should validate_presence_of(:event_trigger) }
    it { should validate_presence_of(:metadata) }
    it { should belong_to(:event_trigger) }
  end
end
