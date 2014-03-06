require 'spec_helper'

describe MessagesController do
  let(:message) { mock_model(Message).as_null_object }

  it "assigns a new message" do
    Message.should_receive(:new).and_return message

    get :new

    expect(assigns :message).to eq(message)
  end

  describe "creating a message" do
    it "creates a new text message" do
      Message.should_receive(:new).with("text" => "This is a test").and_return message
      message.should_receive(:save).and_return true

      post :create, message: { text: "This is a test" }

      expect(response).to render_template(:create)
    end

    it "creates a new file message" do
      Message.should_receive(:new).with("file" => "foo bar").and_return message
      message.should_receive(:save).and_return true

      post :create, message: { file: "foo bar" }

      expect(response).to render_template(:create)
    end

    it "rejects POSTs with no data" do
      post :create, message: {text: ""}

      expect(response).to render_template(:new)
    end
  end

  it "returns the new action when there's a problem saving the record" do
    expect{post :create}.to raise_error ActionController::ParameterMissing
  end

  it "shows the link after a successful create" do
    post :create, message: { text: "This is a test" }

    expect(response).to render_template(:create)
  end

  it "shows an existing message" do
    Message.stub(:find_by!).with(slug: "1").and_return message

    get :show, slug: "1"

    expect(assigns :message).to eq message
  end

  it "deletes a message after it's been viewed" do
    Message.stub(:find_by!).with(slug: "1").and_return message
    message.stub(:file?).and_return false
    message.should_receive(:destroy)

    get :show, slug: "1"
  end

  it "doesn't delete messages with files after rendering" do
    Message.stub(:find_by!).with(slug: "1").and_return message
    message.stub(:file?).and_return true
    message.should_not_receive(:destroy)

    get :show, slug: "1"
  end

  it "sends a file" do
    Message.stub(:find_by!).with(slug: "1").and_return message
    message.stub_chain(:file, :path).and_return "/a/b/c"
    message.stub_chain(:file, :content_type).and_return "foo/bar"
    message.stub(:file_file_name).and_return "foo.bar"
    File.stub_chain(:open, :read).and_return "foo bar"
    controller.should_receive(:send_data).with("foo bar", type: "foo/bar", filename: "foo.bar")
    message.should_receive(:destroy)

    # the view throws an error because we stub out send_file
    expect{ get :download, slug: "1"}.to raise_error ActionView::MissingTemplate 
  end
end
