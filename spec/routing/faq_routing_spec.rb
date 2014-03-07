require 'spec_helper'

describe "faq routes" do
  it "routes /faq to faq#index" do
    expect(get "/faq").to route_to(
      controller: "faq",
      action: "index"
    )
  end
end
