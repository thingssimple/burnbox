class Message < ActiveRecord::Base
  validate :has_text_or_file?

  before_save :set_slug

  def set_slug(salt=Time.now, content=rand)
    self.slug = Digest::MD5.hexdigest("#{salt}:#{content}")
    self
  end

  def has_text_or_file?
    if [text, file_contents].all?{ |attr| attr.blank? }
      errors[:base] << "Either file or text are required"
    end
  end
end
