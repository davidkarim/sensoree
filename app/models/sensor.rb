class Sensor < ActiveRecord::Base
  belongs_to :user
  has_many :events
  has_many :notifications

  enum unit: [:Celsius, :Fahrenheit, :centimeters, :inches, :feet, :milliseconds]
  enum kind: [:temperature, :ultrasound, :internet]
  enum type_of_graph: [:curved_line_graph, :straight_line_graph, :timeline]
  enum notification: [:no_notification, :upper_threshold, :lower_threshold]

  # Create array of two-dimensional arrays containing x and y values
  # for the graph data.
  def graph_data(events, minute_range)
    graph_data =[]
    events.each do | e |
      if (Time.now - e.capture_time) / 60 < minute_range
        graph_data << [e.capture_time, e.value]
      end
    end
    return graph_data
  end

  def notify(phone_number, event)
    count = self.notification_count || 0
    notification_window = self.notification_window || Time.now.to_s

    image_url = []
    unless event.images.empty?
      image_url = event.images.first.photo.url
    end
    if count >= 10  && Time.now - notification_window.to_time > 86400 # secs in a day
      # After 24 hours have passed, reset counter to zero, send notification
      self.notification_count = 0
      self.notification_window = Time.now
      # Send notification
      send_twilio(phone_number, event.value, image_url)
      return true
    elsif count < 10
      # Action to take as long as less than 10 notifications in a 24 hour period
      send_twilio(phone_number, event.value, image_url)
      count += 1
      self.notification_count = count
      self.notification_window = notification_window
      self.save
      return true
    elsif count >= 10  && Time.now - notification_window.to_time <= 86400 # secs in a day
      # Do not send notification, passed limit of 10 notifications per day
      # Do nothing
      return false
    end
  end

  def send_twilio(phone_number, value, image_url)
    account_sid = ENV['TWI_ACCOUNT_SID'] # Twilio Account SID
    auth_token = ENV['TWI_AUTH_TOKEN']   # Twilio Auth Token
    @client = Twilio::REST::Client.new account_sid, auth_token
    if !image_url.empty?
      message_body = "Sensor #{self.name} triggered. Value: #{value} #{self.unit}"
      message = @client.account.messages.create(:body => message_body,
          :to => "+1#{phone_number}",    # User phone number
          :from => "+19542288318",  # Twilio account phone number
          :media_url => "#{image_url}")

    else
      message_body = "Sensor #{self.name} triggered. Value: #{value} #{self.unit}"
      message = @client.account.messages.create(:body => message_body,
          :to => "+1#{phone_number}",    # User phone number
          :from => "+19542288318")  # Twilio account phone number

    end


  end

end
