require 'spec_helper'

describe Message do
  it "sets a slug" do
    message = Message.new.set_slug "abc", 1

    expect(message.slug).to eq "7faac3319aba94a00596f1e271d9da82"
  end

  it "sets the slug on save" do
    message = Message.new text: "test"
    message.should_receive(:set_slug)

    message.save
  end
end
