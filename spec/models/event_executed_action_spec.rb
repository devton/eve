require 'rails_helper'

RSpec.describe EventExecutedAction, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:event) }
    it { should validate_presence_of(:event_trigger_mail_action) }
    it { should belong_to(:event) }
    it { should belong_to(:event_trigger_mail_action) }
  end
end
