require 'rails_helper'

RSpec.describe MailActionCondition, type: :model do
  let(:cond) { create(:mail_action_condition) }

  describe 'validations' do
    it { should validate_presence_of(:json_path) }
    it { should validate_presence_of(:cond_op) }
    it { should validate_presence_of(:match_value) }
  end
end
