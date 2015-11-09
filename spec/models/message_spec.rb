require "rails_helper"

describe Message do
  it "sets a slug" do
    message = Message.new.set_slug "abc", 1

    expect(message.slug).to eq "7faac3319aba94a00596f1e271d9da82"
  end

  it "sets the slug on save" do
    message = Message.new text: "test"
    expect(message).to receive(:set_slug)

    message.save
  end

  it "validates that at either text or file are present" do
    expect(Message.new text: "test").to be_valid
    expect(Message.new file_contents: "foo bar").to be_valid
    expect(Message.new).to_not be_valid
  end
end
