class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.new({text: message_params[:text]}.merge(file_params))

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
      @message.file_contents,
      type: Mime::Type.lookup_by_extension(@message.file_extension).to_s,
      filename: "#{@message.slug}.#{@message.file_extension}"
    )
  end

  def message_params
    params.require(:message).permit(:text, :file)
  end

  def file_params
    unless message_params[:file].nil?
      {
        file_contents: message_params[:file].read,
        file_extension: message_params[:file].original_filename.split(".").last,
      }
    else
      {}
    end
  end
end
