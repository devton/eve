class DashboardController < ApplicationController
  respond_to :html

  def index
    @events = Event.order(created_at: :desc).page(params[:page])
    respond_with @events
  end
end
