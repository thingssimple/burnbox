class MessagesController < ApplicationController
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
    @message = Message.find_by! slug: params[:slug]
    if not @message.file?
      @message.destroy
    end
  end

  def download
    @message = Message.find_by! slug: params[:slug]
    data = File.open(@message.file.path).read
    content_type = @message.file.content_type
    filename = @message.file_file_name
    @message.destroy
    send_data data, type: content_type, filename: filename
  end

  def message_params
    params.require(:message).permit(:text, :file)
  end
end
