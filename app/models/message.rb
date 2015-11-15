require "base64"
require "ezcrypto"
require "message_file"

class Message < ActiveRecord::Base
  attr_reader :key

  after_initialize :setup_crypto
  before_save :encrypt_file_contents, unless: Proc.new { |message| message.file_contents.nil? }
  before_save :encrypt_text, unless: Proc.new { |message| message.text.nil? || message.text.empty? || message.text.blank? }

  validate :has_text_or_file?

  def setup_crypto
    @key = (0...20).map { (65 + rand(26)).chr }.join
  end

  def crypto
    EzCrypto::Key.with_password @key, "salt"
  end

  def encrypt_text
    self.text = crypto.encrypt64 self.text
  end

  def decrypt_text key
    @key = key
    crypto.decrypt64 self.text
  end

  def encrypt_file_contents
    self.file_contents = crypto.encrypt64 self.file_contents
  end

  def decrypt_file_contents key
    @key = key
    crypto.decrypt64 self.file_contents
  end

  def has_text_or_file?
    if [text, file_contents].all?{ |attr| attr.blank? }
      errors[:base] << "Either file or text are required"
    end
  end

  def file_mime_type
    Mime::Type.lookup_by_extension(file_extension).to_s
  end
  
  def file_name
    "#{id}.#{file_extension}"
  end
end
