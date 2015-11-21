class Message < ActiveRecord::Base
  validate :has_text_or_file?

  def has_text_or_file?
    if [text, file_contents].all?{ |attr| attr.blank? }
      errors[:base] << "Either file or text are required"
    end
  end
end
