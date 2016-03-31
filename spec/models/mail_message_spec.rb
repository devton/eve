require 'rails_helper'

RSpec.describe MailMessage, type: :model do
  let(:mail_message) do
    create(:mail_message, {
        subject: 'welcome {{name}}',
        body: 'hello {{name}}'
      })
  end
  let(:parse_attrs) do
    {
      subject_data: {
        'name' => 'ipsum'
      },
      body_data: {
        'name' => 'lorem'
      }
    }
  end

  describe 'validations' do
    before { mail_message }

    it { should validate_presence_of(:subject) }
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:label) }
    it { should validate_uniqueness_of(:label) }
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
        mail_message.parse_subject(parse_attrs.delete(:subject_data))
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
        mail_message.parse_body(parse_attrs.delete(:body_data))
      end

      it 'should parsed_body filled' do
        expect(mail_message.parsed_body).to eq('hello lorem')
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
        expect(mail_message.parsed_body).to eq('hello ')
      end

      it 'should have no errors' do
        expect(mail_message.body_template.errors).not_to be_empty
      end
    end
  end
end
