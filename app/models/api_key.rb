# ApiKey stores a RSA private / public keys to
# encrypt event body
class ApiKey < ActiveRecord::Base
  validates :key, :public_key, :private_key, presence: true
  validates :key, uniqueness: true

  # Handles with a generation of new ApiKey
  # should be used via rake ->
  # $ rake api_keys:generate
  class << self
    def generate!
      ossl = OpenSSL::PKey::RSA.new 2048

      create!(
        key: SecureRandom.hex(16),
        private_key: ossl.to_s,
        public_key: ossl.public_key.to_s
      )
    end
  end

  def rsa_private_key
    @rsa_private_key ||= rsa.new(private_key)
  end

  def rsa_public_key
    @rsa_public_key ||= rsa.new(public_key)
  end

  def decode_message(hash)
    rsa_private_key.private_decrypt(
      Base64.decode64(hash))
  end

  def encode_message(message)
    Base64.encode64(
      rsa_public_key.public_encrypt(message))
  end

  def rsa
    OpenSSL::PKey::RSA
  end
end
