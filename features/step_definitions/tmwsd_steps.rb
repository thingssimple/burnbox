Given /^I am on the homepage$/ do
  visit "/"
end

Given /^a message$/ do
  @message = Message.create text: "This is a test message"
  @message_text = @message.text
end

Given /^a message with a file$/ do
  file = File.open Rails.root.join("features", "fixtures", "upload.txt")
  @message = Message.create! file: file
  @file_path = @message.file.path
end

When /^I create a message$/ do
  @message_text = "This is a message created through the web page"
  fill_in "Type a message here", with: @message_text
  click_button "Upload"
end

When /^I go to that message's page$/ do
  visit message_path @message.slug
end

Then /^I should see the message$/ do
  expect(page).to have_content @message_text
end

Then /^I should see the file$/ do
  url = download_url @message.slug

  expect(page.body).to include(url)
  visit download_path(@message.slug)
end

Then /^the message should deleted$/ do
  expect(Message.where @message.id).to be_empty
end

Then /^the file should deleted$/ do
  expect(Message.where @message.id).to be_empty
  File.delete(@file_path)
end

Then /^I should see the message URL$/ do
  expect(page).to have_field("link", with: message_url(Message.first.slug))
end

When /^I create a message with a file$/ do
  attach_file "message[file]", Rails.root.join("features", "fixtures", "upload.txt")
  click_button "Upload"
end

Then /^the message should have a file$/ do
  expect(Message.first.file).to_not be_nil
end
