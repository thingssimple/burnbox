require "rails_helper"

describe Message do
  it "does not set the file contents when nil" do
    message = Message.new(id: "1b0dad15-732e-45cc-8da4-749b4b21585d", text: "test")
    expect(message).to_not receive(:set_file_contents)

    message.save
  end

  it "sets the file contents on save" do
    message = Message.new(id: "1b0dad15-732e-45cc-8da4-749b4b21585d", file_contents: "foo bar")
    expect(message).to receive(:set_file_contents)

    message.save
  end

  it "validates that at either text or file are present" do
    expect(Message.new(text: "test")).to be_valid
    expect(Message.new(file_contents: "foo bar")).to be_valid
    expect(Message.new).to_not be_valid
  end

  it "decodes its contents" do
    expect(Message.new(file_contents: "Zm9vIGJhcg==\n").read_file).to eq "foo bar"
  end

  it "determines its mime type" do
    expect(Message.new(file_extension: "txt").file_mime_type).to eq "text/plain"
  end

  it "generates a filename from the id and extension" do
    message = Message.new(id: "1b0dad15-732e-45cc-8da4-749b4b21585d", file_extension: "txt")

    expect(message.file_name).to eq "1b0dad15-732e-45cc-8da4-749b4b21585d.txt"
  end
end
