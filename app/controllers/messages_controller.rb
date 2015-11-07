require 'base64'

class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    file = message_params[:file]
    @message = if file
                 Message.new(
                   text: message_params[:text],
                   file_content: Base64.encode64(file.read),
                   file_type: file.content_type,
                   file_extension: file.original_filename.split('.').last,
                 )
               else
                 Message.new(text: message_params[:text])
               end
    if @message.save
      render :create
    else
      render :new
    end
  end

  def show
    @message = Message.find_by! slug: params[:slug]
    if not @message.file_content?
      @message.destroy
    end
  end

  def download
    @message = Message.find_by! slug: params[:slug]
    send_data(Base64.decode64(@message.file_content), type: @message.file_type, filename: "#{@message.slug}.#{@message.file_extension}") 
    @message.destroy
  end

  def message_params
    params.require(:message).permit(:text, :file)
  end
end
