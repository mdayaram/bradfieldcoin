require "openssl"
require "base64"
require "digest"

module BradfieldCoin
  module PKI
    def self.generate_key_pair
      key_pair = OpenSSL::PKey::RSA.new(2048)
      [key_pair.export, key_pair.public_key.export]
    end

    def self.sign(message:, private_key:)
      digested = Digest::SHA2.hexdigest(message)
      key = OpenSSL::PKey::RSA.new(private_key)
      Base64.encode64(key.private_encrypt(digested))
    end

    def self.valid_signature?(message:, signature:, public_key:)
      key = OpenSSL::PKey::RSA.new(public_key)
      decrypted = key.public_decrypt(Base64.decode64(signature))
      Digest::SHA2.hexdigest(message) == decrypted
    end
  end
end
