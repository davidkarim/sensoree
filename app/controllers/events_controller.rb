class EventsController < ApplicationController
  def create
    @event = Event.new

  end

  private
  def event_params
    params.permit(:value,
           :junk)
  end

end
