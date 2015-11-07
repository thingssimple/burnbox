class Message < ActiveRecord::Base
  before_save :set_slug

  def set_slug(salt=Time.now, content=rand)
    self.slug = Digest::MD5.hexdigest("#{salt}:#{content}")
    self
  end
end
