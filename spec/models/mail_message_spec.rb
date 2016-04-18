require 'rails_helper'

RSpec.describe MailMessage, type: :model do
  let(:mail_message) do
    create(:mail_message, {
        subject: 'welcome {{user.name}}',
        body: 'hello {{user.name}} more nested {{user.address.street}}'
      })
  end
  let(:parse_attrs) do
    {
      user: {
        name: 'ipsum',
        address: {
          street: 'foo bar'
        }
      }
    }
  end

  describe 'validations' do
    before { mail_message }

    it { should validate_presence_of(:subject) }
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:label) }
    it { should validate_uniqueness_of(:label) }
    it do
      should allow_values(
        'label_name', 'lname', 'lname12_ln1'
      ).for(:label)
    end

    it do
      should_not allow_value(
        'Label Name', 'LABEL_NAME', 'Label'
      ).for(:label)
    end

  end

  describe '.parse' do
    it do
      expect(mail_message).to receive(:parse_subject)
      expect(mail_message).to receive(:parse_body)
      mail_message.parse(parse_attrs)
    end
  end

  describe '.parse_subject' do
    context 'parse wit all variables' do
      before do
        mail_message.parse_subject(parse_attrs)
      end

      it 'should parsed_subject filled' do
        expect(mail_message.parsed_subject).to eq('welcome ipsum')
      end

      it 'should have no errors' do
        expect(mail_message.subject_template.errors).to eq([])
      end
    end

    context 'parse with error' do
      before do
        mail_message.parse_subject({})
      end

      it 'should parsed_subject filled' do
        expect(mail_message.parsed_subject).to eq('welcome ')
      end

      it 'should have no errors' do
        expect(mail_message.subject_template.errors).not_to be_empty
      end
    end
  end

  describe '.parse_body' do
    context 'parse wit all variables' do
      before do
        mail_message.parse_body(parse_attrs)
      end

      it 'should parsed_body filled' do
        expect(mail_message.parsed_body).to eq('hello ipsum more nested foo bar')
      end

      it 'should have no errors' do
        expect(mail_message.body_template.errors).to eq([])
      end
    end

    context 'parse with error' do
      before do
        mail_message.parse_body({})
      end

      it 'should parsed_subject filled' do
        expect(mail_message.parsed_body).to eq('hello  more nested ')
      end

      it 'should have no errors' do
        expect(mail_message.body_template.errors).not_to be_empty
      end
    end
  end
end
