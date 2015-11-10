require "rails_helper"

describe "messages/show" do
  let(:message) { Message.new(id: "1b0dad15-732e-45cc-8da4-749b4b21585d", text: "This is a test") }

  before do
    assign :message, message

    render
  end

  it "displays the message" do
    expect(rendered).to have_content "This is a test"
  end

  it "displays a notification about the message being deleted" do
    expect(rendered).to have_content "This message has been deleted"
  end

  it "should not render a meta tag" do
    expect(view.content_for(:head)).to eq nil
  end

  context "when the message has a file" do
    let(:message) { Message.new(id: "1b0dad15-732e-45cc-8da4-749b4b21585d", file_contents: "foo bar") }

    it "inserts the meta tag if the message has a file" do
      expect(view.content_for(:head)).to include(download_url(message))
    end
  end
end
