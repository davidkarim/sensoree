class EventsController < ApplicationController
  def create
    @event = Event.new
    "This is a test"
  end

  private
  def event_params
    params.permit(:value,
          :capture_time,
          :notified)
  end

end
