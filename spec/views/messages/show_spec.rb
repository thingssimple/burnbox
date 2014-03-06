require 'spec_helper'

describe "messages/show" do
  let(:message) { Message.new text: "This is a test" }

  before do
    message.set_slug
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
    let(:message) { Message.new file_file_name: "foo bar" }

    it "inserts the meta tag if the message has a file" do
      expect(view.content_for(:head)).to include(download_url(message.slug))
    end
  end
end
