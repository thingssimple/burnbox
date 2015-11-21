require "crypt"
require "rails_helper"

describe Message do
  it "validates that at either text or file are present" do
    expect(Message.new(text: "test")).to be_valid
    expect(Message.new(file_contents: "foo bar")).to be_valid
    expect(Message.new).to_not be_valid
  end

  it "determines its mime type" do
    message = Crypt.new Message.new(file_contents: "foo bar", file_extension: "txt")
    message.save
    expect(message.file_mime_type).to eq "text/plain"
  end

  it "generates a filename from the id and extension" do
    message = Crypt.new Message.new(id: "1b0dad15-732e-45cc-8da4-749b4b21585d", file_contents: "foo bar", file_extension: "txt")
    message.save
    expect(message.file_name).to eq "1b0dad15-732e-45cc-8da4-749b4b21585d.txt"
  end
end
