require "securerandom"

class Crypt
  attr_reader :message, :key

  def initialize(key, message)
    @crypto  = EzCrypto::Key.with_password key, ENV['BB_SECRET']
    @key     = key
    @message = message
  end

  def text
    @crypto.decrypt64 @message.text
  rescue OpenSSL::Cipher::CipherError
    raise CryptError
  end

  def file_contents
    @crypto.decrypt64 @message.file_contents
  rescue OpenSSL::Cipher::CipherError
    raise CryptError
  end

  def destroy
    @message.destroy
  end

  def self.find(id, key)
    Crypt.new key, Message.find(id)
  end

  class CryptError < StandardError
  end
end
