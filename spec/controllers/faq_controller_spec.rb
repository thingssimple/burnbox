require "rails_helper"

describe FaqController do
  it "renders the index action" do
    expect(get :index).to render_template("index")
  end
end
