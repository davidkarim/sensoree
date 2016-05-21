class EventsController < ApplicationController

  protect_from_forgery with: :null_session

  def create
    # binding.pry
    event_values = event_params.merge(sensor_id: "1")
    @event = Event.new(event_values)
    # binding.pry

    respond_to do |format|
      if @event.save
        format.html { redirect_to events_show_path, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
        # binding.pry
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
        # binding.pry
      end
    end

  end

  private
  def event_params
    params.permit(:value,
          :capture_time,
          :notified)
  end

end
