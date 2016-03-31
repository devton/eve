require 'rails_helper'

RSpec.describe MailMessage, type: :model do
  let(:mail_message) { create(:mail_message) }

  describe "validations" do
    before { mail_message} 

    it { should validate_presence_of(:subject) }
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:label) }
    it { should validate_uniqueness_of(:label) }
  end
end
