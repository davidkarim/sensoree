class EventsController < ApplicationController

  protect_from_forgery with: :null_session

  def create
    # Remove api_key from parameters list and search for user
    new_params = event_params
    api_key = new_params.delete(:api_key)
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
      time_dif = Time.zone.parse(new_params["capture_time"]).utc - last_time if sensor
    end

    # Don't accept events with a frequency less than 30 seconds
    if @user && sensor && time_dif > 30
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
          :notified)
  end

  def send_twilio
    account_sid = ENV['TWI_ACCOUNT_SID'] # Twilio Account SID
    auth_token = ENV['TWI_AUTH_TOKEN']   # Twilio Auth Token
    @client = Twilio::REST::Client.new account_sid, auth_token
    message = @client.account.messages.create(:body => "Hello from Ruby",
        :to => "+19542243598",    # Replace with your phone number
        :from => "+19542288318")  # Replace with your Twilio number
    rescue Twilio::REST::RequestError => e
      puts e.message
  end

end
