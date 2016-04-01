require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { create(:event) }

  describe 'validations' do
    before { event }

    it { should validate_presence_of(:event_trigger) }
    it { should validate_presence_of(:metadata) }
    it { should belong_to(:event_trigger) }
    it { should have_many(:executed_actions) }

    it do
      should allow_value({
        trigger_name: 'foo_bar',
        to: 'example@example.com'
      }).for(:metadata)
    end

    it do
      should_not allow_value({
        trigger_name: 'foo_bar'
      }, {}, {to: 'foo@foo.com'}).for(:metadata)
    end
  end
end
