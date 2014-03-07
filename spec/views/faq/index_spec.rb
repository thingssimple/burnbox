require 'spec_helper'

describe "faq/index" do
  it "has a new message form" do
    render

    expect(rendered).to_not be_empty
  end
end
