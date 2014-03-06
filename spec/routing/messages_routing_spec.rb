require 'spec_helper'

describe "messages routes" do
  it "routes slugs to messages#show" do
    expect(get "/messages/123").to route_to(
      controller: "messages",
      action: "show",
      slug: "123"
    )
  end

  it "routes slugs to messages#download" do
    expect(get "/messages/123/download").to route_to(
      controller: "messages",
      action: "download",
      slug: "123"
    )
  end
end
