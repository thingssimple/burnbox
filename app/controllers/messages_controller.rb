require "message_params"

class MessagesController < ApplicationController
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
    @message = Message.find_by! slug: params[:slug]
    if @message.file_contents.nil?
      @message.destroy
    end
  end

  def download
    @message = Message.find_by! slug: params[:slug]
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
end
