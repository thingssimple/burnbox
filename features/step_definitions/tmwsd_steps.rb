Given(/^I am on the homepage$/) do
  visit "/"
end

Given(/^a message$/) do
  @message = Message.create text: "This is a test message"
  @message_text = @message.text
end

Given(/^a message with a file$/) do
  @message = Message.create! file_contents: "some test", file_extension: "txt"
end

When(/^I create a message$/) do
  @message_text = "This is a message created through the web page"
  fill_in "Type a message here", with: @message_text
  click_button "Upload"
end

When(/^I go to that message's page$/) do
  visit message_path(@message)
end

Then(/^I should see the message$/) do
  expect(page).to have_content @message_text
end

Then(/^I should see the file$/) do
  url = download_url(@message)

  expect(page.body).to include(url)
  visit url
end

Then(/^the message should deleted$/) do
  expect(Message.where(id: @message.id)).to be_empty
end

Then(/^I should see the message URL$/) do
  expect(page).to have_field("link", with: message_url(Message.first))
end

When(/^I create a message with a file$/) do
  attach_file "message[file]", Rails.root.join("features", "fixtures", "upload.txt")
  click_button "Upload"
end

Then(/^the message should have a file$/) do
  expect(Message.first.file_contents).to_not be_nil
end

When(/^I POST the following messages:$/) do |table|
  header "Accept", "application/json"
  header "Content-Type", "application/json"
  post messages_path, {message: table.rows_hash}.to_json
end

Then(/^I should see "(.*?)"$/) do |content|
  expect(last_response.body).to eq content
end

Then(/^the response should include a "(.*?)"$/) do |key|
  expect(JSON.parse(last_response.body)).to have_key(key)
end
