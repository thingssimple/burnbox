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
    let(:key)            { "test key" }
    let(:secret_message) { "secret message" }
    let(:guid)           { "1b0dad15-732e-45cc-8da4-749b4b21585d" }
    let(:message)        { Message.new(text: secret_message) }
    let(:crypt)          { Crypt.new message }

    before do
      allow(Crypt).to receive(:find).with(guid, key) { crypt }
      allow(crypt).to receive(:text) { "secret message" }
    end

    it "shows an existing message" do
      get :show, id: guid, key: key

      expect(assigns :message).to eq crypt
    end

    it "deletes a message after it's been viewed" do
      allow(message).to receive(:file_contents) { nil }
      expect(crypt).to receive(:destroy)

      get :show, id: guid, key: key
    end

    it "doesn't delete messages with files after rendering" do
      allow(message).to receive(:file_contents) { "foo" }
      expect(crypt).to_not receive(:destroy)

      get :show, id: guid, key: key
    end
  end

  describe "downloading a file" do
    let(:key)            { "test key" }
    let(:guid)           { "1b0dad15-732e-45cc-8da4-749b4b21585d" }
    let(:message) do
      Message.new(
        id: guid,
        file_contents: "c2VjcmV0IG1lc3NhZ2U=\n",
        file_extension: "txt",
      )
    end
    let(:crypt)          { Crypt.new message }

    before do
      allow(Crypt).to receive(:find).with(guid, key) { crypt }
      allow(crypt).to receive(:file_contents) { "secret message" }
    end

    it "sends a file" do
      expect(controller).to receive(:send_data).with("secret message", type: "text/plain", filename: "1b0dad15-732e-45cc-8da4-749b4b21585d.txt")
      expect(crypt).to receive(:destroy)

      # the view throws an error because we stub out send_file
      expect{ get :download, id: guid, key: key}.to raise_error ActionView::MissingTemplate 
    end
  end
end
