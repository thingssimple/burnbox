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
    begin
      @decrypted_text = @message.decrypt_text(params[:key])
      if @message.file_contents.nil?
        @message.destroy
      end
    rescue OpenSSL::Cipher::CipherError
       raise "Could Not Decrypt"
    end
  end

  def download
    begin
      decrypted_file_contents = @message.decrypt_file_contents(params[:key])
      @message.destroy
      send_data(
        decrypted_file_contents,
        type: @message.file_mime_type,
        filename: @message.file_name,
      )
    rescue OpenSSL::Cipher::CipherError
       raise "Could Not Decrypt"
    end
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
