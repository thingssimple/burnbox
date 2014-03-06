class Message < ActiveRecord::Base
  MAX_FILE_SIZE = 10.megabytes

  has_attached_file :file
  validates_attachment_size :file, in: 0..MAX_FILE_SIZE
  do_not_validate_attachment_file_type :file
  validate :has_text_or_file?

  before_save :set_slug

  def set_slug(salt=Time.now, content=rand)
    self.slug = Digest::MD5.hexdigest("#{salt}:#{content}")
    self
  end

  def has_text_or_file?
    if [text, file].all?{ |attr| attr.blank? }
      errors[:base] << "Either file or text are required"
    end
  end
end
