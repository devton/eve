# This controller handles with incoming events  via api
class Api::IncomingEventsController < ApplicationController
  respond_to :json

  def create
    unless trigger.present?
      return render json: { error: 'trigger not fount' }, status: :not_found
    end

    event = Event.create(event_params.merge(event_trigger: trigger))

    if event.persisted?
      EventsProcessJob.perform_later(event.id)
      render json: event, status: :created
    else
      render json: { errors: event.errors }, status: :bad_request
    end
  end

  def trigger
    @trigger ||= EventTrigger.find_by_trigger_name(event_params[:trigger_name])
  end

  def event_params
    params.require(:event).permit(
      :trigger_name,
      :to, :from, :reply_to
    ).tap do |w|
      w[:subject_data] = params[:event][:subject_data]
      w[:body_data] = params[:event][:body_data]
      w[:extra_data] = params[:event][:extra_data]
    end
  end
end
