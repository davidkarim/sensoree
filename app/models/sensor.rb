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

  def notify(value)
    send_twilio(value)
  end

  def send_twilio(value)
    account_sid = ENV['TWI_ACCOUNT_SID'] # Twilio Account SID
    auth_token = ENV['TWI_AUTH_TOKEN']   # Twilio Auth Token
    @client = Twilio::REST::Client.new account_sid, auth_token
    message = @client.account.messages.create(:body => "Sensor #{self.name} triggered. Value: #{value} #{self.unit}",
        :to => "+19542243598",    # User phone number
        :from => "+19542288318")  # Twilio account phone number
    rescue Twilio::REST::RequestError => e
      puts e.message
  end

end
