require "message_params"

class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :download]

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if @message.save
      render :create
    else
      render :new
    end
  end

  def show
    if @message.file_contents.nil?
      @message.destroy
    end
  end

  def download
    @message.destroy
    send_data(
      @message.read_file,
      type: @message.file_mime_type,
      filename: @message.file_name,
    )
  end

  def message_params
    MessageParams.generate(params.require(:message).permit(:text, :file))
  end

  def set_message
    @message = Message.find(params[:id])
  end
end
