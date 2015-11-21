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

  def file_extension
    @crypto.decrypt64 @message.file_extension
  rescue OpenSSL::Cipher::CipherError
    raise CryptError
  end

  def file_name
    "#{@message.id}.#{file_extension}"
  end

  def file_mime_type
    Mime::Type.lookup_by_extension(file_extension).to_s
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
      @message.file_contents  = @crypto.encrypt64 @message.file_contents
      @message.file_extension = @crypto.encrypt64 @message.file_extension
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
