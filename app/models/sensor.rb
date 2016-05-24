class Sensor < ActiveRecord::Base
  belongs_to :user
  has_many :events
  has_many :notifications

  enum unit: [:Celsius, :Fahrenheit, :cm, :in, :feet]
  enum kind: [:temperature, :ultrasound]
  enum type_of_graph: [:line_graph, :bar_graph, :on_off]

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
