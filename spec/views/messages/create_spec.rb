require "rails_helper"

describe "messages/create" do
  let(:message) { Message.new(id: "1b0dad15-732e-45cc-8da4-749b4b21585d", text: "This is a test") }

  before do
    assign :message, message

    render
  end

  it "displays the link" do
    expect(rendered).to have_field("link", with: message_url(message))
  end
end
