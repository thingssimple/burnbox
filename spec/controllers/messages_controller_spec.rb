require "rails_helper"

describe MessagesController do
  let(:message) { Message.new(id: 1) }

  it "assigns a new message" do
    get :new

    expect(assigns(:message)).to_not be_nil
  end

  describe "creating a message" do
    it "renders the create template when the message is valid" do
      expect_any_instance_of(Message).to receive(:save) { true }

      post :create, message: { text: "This is a test" }

      expect(response).to render_template(:create)
    end

    it "renders the new template when the message is invalid" do
      expect_any_instance_of(Message).to receive(:save) { false }

      post :create, message: {text: ""}

      expect(response).to render_template(:new)
    end

    it "returns the new action when there's a problem saving the record" do
      expect{post :create}.to raise_error ActionController::ParameterMissing
    end
  end

  describe "showing messages" do
    before do
      allow(Message).to receive(:find_by!).with(slug: "1") { message }
    end

    it "shows an existing message" do
      get :show, slug: "1"

      expect(assigns :message).to eq message
    end

    it "deletes a message after it's been viewed" do
      allow(message).to receive(:file?) { false }
      expect(message).to receive(:destroy)

      get :show, slug: "1"
    end

    it "doesn't delete messages with files after rendering" do
      allow(message).to receive(:file?) { true }
      expect(message).to_not receive(:destroy)

      get :show, slug: "1"
    end
  end

  describe "downloading a file" do
    before do
      allow(Message).to receive(:find_by!).with(slug: "1") { message }
    end

    it "sends a file" do
      allow(message).to receive_message_chain(:file, :path) { "/a/b/c" }
      allow(message).to receive_message_chain(:file, :content_type) { "foo/bar" }
      allow(message).to receive_message_chain(:file, :file_name) { "foo.bar" }
      allow(File).to receive_message_chain(:open, :read) { "foo bar" }
      expect(controller).to receive(:send_data).with("foo bar", type: "foo/bar", filename: "foo.bar")
      expect(message).to receive(:destroy)

      # the view throws an error because we stub out send_file
      expect{ get :download, slug: "1"}.to raise_error ActionView::MissingTemplate 
    end
  end
end
