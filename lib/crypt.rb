require "securerandom"

class Crypt
  attr_reader :message, :key

  def initialize(message, key=SecureRandom.hex(30))
    @crypto  = EzCrypto::Key.with_password key, ENV['BB_SECRET']
    @key     = key
    @message = message
  end

  def has_file?
    not @message.file_contents.nil?
  end

  def has_text?
    not @message.text.blank?
  end

  # Message API

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

  def file_mime_type
    @message.file_mime_type
  end

  def file_name
    @message.file_name
  end

  # Active Record API

  def errors
    @message.errors
  end

  def destroy
    @message.destroy
  end

  def save
    if has_file?
      @message.file_contents = @crypto.encrypt64 @message.file_contents
    end
    if has_text?
      @message.text = @crypto.encrypt64 @message.text
    end
    @message.save
  end

  def self.find(id, key)
    Crypt.new Message.find(id), key
  end

  # Error

  class CryptError < StandardError
  end
end
