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

      create!({
        key: SecureRandom.hex(16),
        private_key: ossl.to_s,
        public_key: ossl.public_key.to_s
      })
    end
  end
end
