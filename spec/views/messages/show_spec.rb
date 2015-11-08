require 'spec_helper'

describe "messages/show" do
  let(:verified_text) { "This is a test" }
  let(:message) { Message.new slug: "foo bar" }

  before do
    message.set_slug
    assign :message, message
    assign :verified_text, verified_text

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
    let(:message) { Message.new(slug: "foo bar", file_content: "bar foo") }

    it "inserts the meta tag if the message has a file" do
      expect(view.content_for(:head)).to include(download_url(message.slug))
    end
  end
end
