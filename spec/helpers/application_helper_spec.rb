require 'spec_helper'

describe ApplicationHelper do
  it "renders markdown" do
    expect(helper.markdown("# Foo")).to eq "<h1>Foo</h1>\n"
  end

  it "deals with nil text" do
    expect(helper.markdown(nil)).to eq ""
  end
end
