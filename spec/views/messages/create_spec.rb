require 'spec_helper'

describe "messages/create" do
  let(:message) { Message.new text: "This is a test" }

  before do
    message.set_slug
    assign :message, message

    render
  end

  it "displays the link" do
    expect(rendered).to have_field("link", with: message_url(message.slug))
  end
end
