class MailMessagesController < ApplicationController
  respond_to :html

  def index
    @mail_messages = MailMessage.order(created_at: :desc).page(params[:page])
    respond_with @mail_messages
  end

  def show
    @mail_message = MailMessage.find(params[:id])
    respond_with @mail_message
  end

  def new
    @mail_message = MailMessage.new
    respond_with @mail_message
  end

  def edit
    @mail_message = MailMessage.find(params[:id])
    respond_with @mail_message
  end

  def create
    @mail_message = MailMessage.new(mail_message_params)
    flash[:notice] = 'email template created' if @mail_message.save
    respond_with @mail_message
  end

  def update
    @mail_message = MailMessage.find params[:id]
    @mail_message.update_attributes(mail_message_params)

    if @mail_message.valid?
      flash[:notice] = 'email template updated'
      redirect_to @mail_message
    else
      render :edit
    end
  end

  def remove
  end

  def destroy
  end

  def mail_message_params
    params.require(:mail_message).permit(:label, :subject, :body)
  end
end
