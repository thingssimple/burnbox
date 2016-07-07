require "rails_helper"

describe ApplicationController do
  describe "#is_link_expander?" do
    it "is true for link expanding user agents" do
      request.env["HTTP_USER_AGENT"] = "Slackbot-LinkExpanding 1.0 (+https://api.slack.com/robots)"

      expect(controller.is_link_expander?).to be_truthy
    end

    it "is false for non link expanding user agents" do
      request.env["HTTP_USER_AGENT"] = "Mozilla/5.0 (Macintosh; U; Mac OS X 10_6_1; en-US) AppleWebKit/530.5 (KHTML, like Gecko) Chrome/ Safari/530.5"

      expect(controller.is_link_expander?).to be_falsy
    end
  end
end
