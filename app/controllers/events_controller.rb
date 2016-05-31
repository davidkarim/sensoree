class EventsController < ApplicationController

  protect_from_forgery with: :null_session

  def create
    # Remove api_key from parameters list and search for user
    new_params = event_params
    api_key = new_params.delete(:api_key)
    photo_params = new_params.delete(:photo)
    @user = User.find_by(api_key: api_key)
    # Look for sensor, if none is found find_by_id returns nil
    if @user
      sensor = @user.sensors.find_by_id(event_params[:sensor_id])
      if sensor.events.empty?
        # First event acquired by this sensor, assume last was 24 hours ago to allow to accept
        last_time = 24.hours.ago
      else
        last_time = sensor.events.last.capture_time.to_time
      end
      # If no capture time is sent, use the current time
      if new_params[:capture_time] == nil
        new_params[:capture_time] = Time.now.to_s
      end
      # Calculate difference in seconds, between last event, and current one
      time_dif = Time.zone.parse(new_params["capture_time"]).utc - last_time if sensor
    end

    # Don't accept events with a frequency less than 30 seconds
    if @user && sensor && time_dif > 5
      @event = Event.new(new_params)
      @event.notified = false # Default value for notifications

      event_save_success = @event.save
      if photo_params
        @image = Image.new(photo: photo_params)
        @image.event= @event
        image_save_success = @image.save
      end

      # Check for notification setting, and ensure there is a phone number provisioned
      unless sensor.no_notification?
        if sensor.upper_threshold? && @event.value > sensor.notification_value
          # Value is above threshold, send notification (if phone number provisioned)
          if !@user.phone_number.nil? && @user.phone_number.length > 9
            result = sensor.notify(@user.phone_number, @event)
            @event.notified = true if result
          end
        elsif sensor.lower_threshold? && @event.value < sensor.notification_value
          # Value is below threshold, send notification (if phone number provisioned)
          if !@user.phone_number.nil? && @user.phone_number.length > 9
            result = sensor.notify(@user.phone_number, @event)
            @event.notified = true if result
          end
        else
          @event.notified = false
        end
      end


      respond_to do |format|
        if event_save_success
          format.html { redirect_to events_show_path, notice: 'Event was successfully created.' }
          # format.json { render :show, status: :created, location: @event }
          format.json { render :show }
        else
          format.html { render :new }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end # respond_to
    else
      if time_dif && time_dif < 30
        error_msg = "Increase rate of capture beyond 30 seconds"
      else
        error_msg = "Check your API Key and Sensor ID values"
      end
      respond_to do |format|
          format.json { render :json => {
           :status => :unauthorized,
           :message => error_msg,
           :html => "<b>#{error_msg}</b>"
          }.to_json }
          format.html { render text:"<h2>#{error_msg}</h2>" }
      end
    end # if @user

  end # def create

  private
  def event_params
    params.permit(:api_key,
          :sensor_id,
          :value,
          :capture_time,
          :photo,
          :notified)
  end

end
