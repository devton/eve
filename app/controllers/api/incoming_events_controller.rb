# This controller handles with incoming events  via api
class Api::IncomingEventsController < ApplicationController
  skip_before_filter :authenticate_user!
  protect_from_forgery with: :null_session
  respond_to :json

  # Handles with creation of events
  # Request body in json format:
  # {
  #   event_name: 'tr_name',
  #   session_id: '1234',
  #   email: 'to@email.com',
  #   from: 'from@email.com',
  #   reply_to: 'reply@email.com',
  #   subject_data: { user: { name: 'foor' } },
  #   body_data: { user: { name: 'foor' } },
  #   extra_data: {}
  # }
  # should be ecrypted over ApiKey public key an passed in request
  # body like:
  # { key: ApiKey.key, event_hash: ApiKey.encode_message('message') }
  def create
    unless api_key.present?
      return render json: { error: 'invalid key' }, status: :bad_request
    end

    unless trigger.present?
      return render json: { error: 'trigger not fount' }, status: :not_found
    end

    event = Event.create(
      event_trigger: trigger,
      metadata: event_data
    )

    if event.persisted?
      EventsProcessJob.perform_later(event.id)
      render json: event, status: :created
    else
      render json: { errors: event.errors }, status: :bad_request
    end
  rescue OpenSSL::PKey::RSAError
    render json: { error: 'invalid hash' }, status: :bad_request
  end

  def trigger
    @trigger ||= EventTrigger.find_by_trigger_name(event_data[:event_name])
  end

  def event_data
    @event_data ||= ActiveSupport::JSON.decode(
      api_key.decode_message(params[:event_hash])).deep_symbolize_keys!
  end

  def api_key
    @api_key ||= ApiKey.find_by_key params[:key]
  end
end
