Given(/^I am on the homepage$/) do
  visit "/"
end

Given(/^I created a message$/) do
  step "I am on the homepage"
  step "I create a message"
  @message_url_with_key = find_field("link").value
end

Given(/^I created a message with a file$/) do
  step "I am on the homepage"
  step "I create a message with a file"
  @message_url_with_key = find_field("link").value
end

When(/^I create a message$/) do
  @message_text = "This is a message created through the web page"
  fill_in "Type a message here", with: @message_text
  click_button "Upload"
end

When(/^I go to that message's page$/) do
  visit @message_url_with_key
end

Then(/^I should see the message$/) do
  expect(page).to have_content @message_text
end

Then(/^I should see the file$/) do
  uri = URI(@message_url_with_key)
  key = uri.query.split("=").last
  url = download_url(Message.first, key: key)

  expect(page.body).to include(url)
  visit url
end

Then(/^the message should deleted$/) do
  expect(Message.all).to be_empty
end

Then(/^I should see the message URL$/) do
  message_url_with_key = find_field("link").value
  expect(message_url_with_key).to include(message_url(Message.first, key: ""))
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
