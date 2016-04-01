class EventTriggersController < ApplicationController
  respond_to :html
  def index
    @event_triggers = EventTrigger.order(created_at: :desc).page(params[:page])
    respond_with @event_triggers
  end

  def show
    @event_trigger = EventTrigger.find params[:id]
    @event_trigger.mail_actions.build unless @event_trigger.mail_actions.present?
    respond_with @event_trigger
  end

  def new
    @event_trigger = EventTrigger.new
  end

  def edit
    @event_trigger = EventTrigger.find params[:id]
    respond_with @event_trigger
  end

  def create
    @event_trigger = EventTrigger.new(event_trigger_params)
    flash[:notice] = 'event trigger created' if @event_trigger.save
    respond_with @event_trigger
  end

  def update
    @event_trigger = EventTrigger.find params[:id]
    @event_trigger.update_attributes(event_trigger_params)

    if @event_trigger.valid?
      flash[:notice] = 'event trigger updated'
      redirect_to @event_trigger
    else
      if event_trigger_params[:mail_actions_attributes].present?
        render :show
      else
        render :edit
      end
    end
  end

  def remove
  end

  def destroy
  end

  def event_trigger_params
    params.require(:event_trigger).permit(:trigger_name, :description, mail_actions_attributes: %i( mail_message_id event_trigger_id ))
  end
end
