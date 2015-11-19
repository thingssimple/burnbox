class Message < ActiveRecord::Base
  validate :has_text_or_file?

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
