require "message_params"

class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :download]
  skip_before_action :verify_authenticity_token, if: :json_request?

  def new
    @message = Message.new
  end

  def create
    @message = Message.new message_params

    if @message.save
      render :create
    else
      render :new
    end
  end

  def show
    @decrypted_text = @message.decrypt_text(params[:key])
    if @message.file_contents.nil?
      @message.destroy
    end
  end

  def download
    @message.destroy
    send_data(
      @message.decrypt_file_contents(params[:key]),
      type: @message.file_mime_type,
      filename: @message.file_name,
    )
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def json_request?
    request.format.json?
  end

  def message_params
    MessageParams.generate(params.require(:message).permit(:text, :file))
  end
end
