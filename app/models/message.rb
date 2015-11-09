require "message_file"

class Message < ActiveRecord::Base
  before_save :set_slug
  before_save :set_file_contents, unless: Proc.new { |message| message.file_contents.nil? }

  validate :has_text_or_file?

  def set_slug(salt=Time.now, content=rand)
    self.slug = Digest::MD5.hexdigest("#{salt}:#{content}")
    self
  end

  def set_file_contents
    self.file_contents = MessageFile.encode(self.file_contents)
  end

  def has_text_or_file?
    if [text, file_contents].all?{ |attr| attr.blank? }
      errors[:base] << "Either file or text are required"
    end
  end

  def read_file
    MessageFile.decode(file_contents)
  end

  def file_mime_type
    Mime::Type.lookup_by_extension(file_extension).to_s
  end
  
  def file_name
    "#{slug}.#{file_extension}"
  end
end
