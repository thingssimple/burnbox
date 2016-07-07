require "crypt"
require "message_params"

class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :json_request?

  def new
    @message = Crypt.new Message.new
  end

  def create
    @message = Crypt.new Message.new message_params
    if @message.save
      render :create
    else
      render :new
    end
  end

  def show
    logger.info "User agent: #{request.user_agent}"
    @message = Crypt.find params[:id], key_param
    @message.text # triggers CryptError, but used in view
    unless @message.has_file?
      @message.destroy
    end
  rescue Crypt::CryptError
    raise ActiveRecord::RecordNotFound
  end

  def download
    @message = Crypt.find params[:id], key_param
    send_data(
      @message.file_contents,
      type: @message.file_mime_type,
      filename: @message.file_name,
    )
    @message.destroy
  rescue Crypt::CryptError
    raise ActiveRecord::RecordNotFound
  end

  def json_request?
    request.format.json?
  end

  def key_param
    params.require(:key)
  end

  def message_params
    MessageParams.generate(params.require(:message).permit(:text, :file))
  end
end
