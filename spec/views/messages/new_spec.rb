require 'spec_helper'

describe "messages/new" do
  it "has a new message form" do
    message = Message.new
    assign :message, message

    render
    expect(rendered).to have_selector "form[action='#{messages_path}'][method='post']"
    expect(rendered).to have_field "message[file]"
    expect(rendered).to have_field "Type a message here"
    expect(rendered).to have_button "Upload"
  end
end
