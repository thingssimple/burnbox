require "ostruct"
require "message_params"

describe MessageParams do
  it "passes along the text unaltered" do
    expect(MessageParams.generate(text: "foo")).to eq(text: "foo")
  end

  it "sets the file fields" do
    file = OpenStruct.new(read: "foo bar", original_filename: "test.txt")

    expect(MessageParams.generate(file: file)).to eq(file_contents: "foo bar", file_extension: "txt")
  end
end
