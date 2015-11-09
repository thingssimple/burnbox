require "base64"

class MessageFile
  def self.encode(contents)
    Base64.encode64(contents)
  end

  def self.decode(contents)
    Base64.decode64(contents)
  end
end
