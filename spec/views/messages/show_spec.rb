require "crypt"
require "rails_helper"

describe "messages/show" do
  context "when the message has a file" do
    let(:message) { Crypt.new Message.new(id: "1b0dad15-732e-45cc-8da4-749b4b21585d", file_contents: "foo bar", file_extension: "txt") }

    before do
      assign :message, message
    end

    it "inserts the meta tag if the message has a file" do
      allow(message).to receive(:text) { "secret message" }
      render
      expect(view.content_for(:head)).to include(download_url(message.message, key: message.key))
    end
  end
end
