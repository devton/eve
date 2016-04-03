require 'rails_helper'

RSpec.describe SendgridEvent, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:event_executed_action) }
    it { should validate_presence_of(:event) }
    it { should validate_presence_of(:email) }
  end
end
