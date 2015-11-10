require "rails_helper"

describe "messages routes" do
  it "routes slugs to messages#show" do
    expect(get "/messages/123").to route_to(
      controller: "messages",
      action: "show",
      id: "123"
    )
  end

  it "routes IDs to messages#download" do
    expect(get "/messages/123/download").to route_to(
      controller: "messages",
      action: "download",
      id: "123"
    )
  end
end
