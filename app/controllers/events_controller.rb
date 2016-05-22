class EventsController < ApplicationController

  protect_from_forgery with: :null_session

  def create

    # Remove api_key from parameters list and search for user
    new_params = event_params
    api_key = new_params.delete(:api_key)
    # binding.pry
    @user = User.find_by(api_key: api_key)

    # Look or sensor, if none is found find_by_id returns nil
    sensor = @user.sensors.find_by_id(event_params[:sensor_id]) if @user

    if @user && sensor
      @event = Event.new(new_params)

      respond_to do |format|
        if @event.save
          format.html { redirect_to events_show_path, notice: 'Event was successfully created.' }
          # format.json { render :show, status: :created, location: @event }
          format.json { render :show }

        else
          format.html { render :new }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end # respond_to
    else
      respond_to do |format|
          format.json { render :json => {
           :status => :unauthorized,
           :message => "Check your API Key and Sensor ID values",
           :html => "<b>Check your API Key and Sensor ID values</b>"
        }.to_json }
      end
      # binding.pry
    end # if @user

  end # def create

  private
  def event_params
    params.permit(:api_key,
          :sensor_id,
          :value,
          :capture_time,
          :notified)
  end

end
