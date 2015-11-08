require 'base64'
require 'gpgme'

class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    file = message_params[:file]
    signed_text = Base64.encode64(sign(message_params[:text]).to_s)
    @message = if file
                 signed_file = Base64.encode64(sign(file.read).to_s)
                 Message.new(
                   text: signed_text,
                   file_content: signed_file,
                   file_type: file.content_type,
                   file_extension: file.original_filename.split('.').last,
                 )
               else
                 Message.new(text: signed_text)
               end
    if @message.save
      render :create
    else
      render :new
    end
  end

  def show
    @message = Message.find_by! slug: params[:slug]
    @verified_text = verify Base64.decode64(@message.text)
    if not @message.file_content?
      @message.destroy
    end
  end

  def download
    @message = Message.find_by! slug: params[:slug]
    verified_file = verify Base64.decode64(@message.file_content)
    send_data(verified_file, type: @message.file_type, filename: "#{@message.slug}.#{@message.file_extension}")
    @message.destroy
  end

  def sign data
    GPGME::Crypto.new.sign data, :signer => "burnbox@thingssimple.com"
  end

  def verify data
    GPGME::Crypto.new.verify data do |sig|
      raise "Failed Verification" if not sig.valid?
    end
  end

  def message_params
    params.require(:message).permit(:text, :file)
  end
end
