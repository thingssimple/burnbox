require "rails_helper"

describe MessagesController do
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
    let(:message) { Message.new(text: "secret message") }

    before do
      allow(Message).to receive(:find).with("1b0dad15-732e-45cc-8da4-749b4b21585d") { message }
    end

    it "shows an existing message" do
      get :show, id: "1b0dad15-732e-45cc-8da4-749b4b21585d"

      expect(assigns :message).to eq message
    end

    it "deletes a message after it's been viewed" do
      allow(message).to receive(:file_contents) { nil }
      expect(message).to receive(:destroy)

      get :show, id: "1b0dad15-732e-45cc-8da4-749b4b21585d"
    end

    it "doesn't delete messages with files after rendering" do
      allow(message).to receive(:file_contents) { "foo" }
      expect(message).to_not receive(:destroy)

      get :show, id: "1b0dad15-732e-45cc-8da4-749b4b21585d"
    end
  end

  describe "downloading a file" do
    let(:message) do
      Message.new(
        id: "1b0dad15-732e-45cc-8da4-749b4b21585d",
        file_contents: "c2VjcmV0IG1lc3NhZ2U=\n",
        file_extension: "txt",
      )
    end

    before do
      allow(Message).to receive(:find).with("1b0dad15-732e-45cc-8da4-749b4b21585d") { message }
    end

    it "sends a file" do
      expect(controller).to receive(:send_data).with("secret message", type: "text/plain", filename: "1b0dad15-732e-45cc-8da4-749b4b21585d.txt")
      expect(message).to receive(:destroy)

      # the view throws an error because we stub out send_file
      expect{ get :download, id: "1b0dad15-732e-45cc-8da4-749b4b21585d"}.to raise_error ActionView::MissingTemplate 
    end
  end
end
