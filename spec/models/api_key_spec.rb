require 'rails_helper'

RSpec.describe ApiKey, type: :model do

  describe 'validations' do
    before { create(:api_key) }

    it { should validate_presence_of(:key) }
    it { should validate_uniqueness_of(:key) }
    it { should validate_presence_of(:public_key) }
    it { should validate_presence_of(:private_key) }
  end

  describe '#generate!' do
    it 'should generate a new ApiKey record with RSA' do
      gen = ApiKey.generate!

      expect(gen).to be_kind_of(ApiKey)

      private_key = OpenSSL::PKey::RSA.new(gen.private_key)
      public_key = OpenSSL::PKey::RSA.new(gen.public_key)
      expect(private_key.private?).to eq(true)
      expect(public_key.private?).to eq(false)
      expect(public_key.public?).to eq(true)
    end
  end

  describe 'rsa wrappers' do
    let!(:api_key) { ApiKey.generate! }

    it '.rsa_private_key' do
      expect(api_key.rsa_private_key).to be_kind_of(
        OpenSSL::PKey::RSA)
    end
    it '.rsa_public_key' do
      expect(api_key.rsa_public_key).to be_kind_of(
        OpenSSL::PKey::RSA)
    end

    it '.decode_message' do
      expect(api_key.rsa_private_key).to receive(
        :private_decrypt).with('RSAMSG')
      api_key.decode_message('RSAMSG')
    end

    it '.encode_message' do
      expect(api_key.rsa_public_key).to receive(
        :public_encrypt).with('RSAMSG')
      api_key.encode_message('RSAMSG')
    end
  end
end
