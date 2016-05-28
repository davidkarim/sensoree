class Sensor < ActiveRecord::Base
  belongs_to :user
  has_many :events
  has_many :notifications

  enum unit: [:Celsius, :Fahrenheit, :centimeters, :inches, :feet, :milliseconds]
  enum kind: [:temperature, :ultrasound, :internet]
  enum type_of_graph: [:curved_line_graph, :straight_line_graph, :timeline]

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

end
