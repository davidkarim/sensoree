class Sensor < ActiveRecord::Base
  belongs_to :user
  has_many :events
  has_many :notifications

  enum unit: [:Celsius, :Fahrenheit, :cm, :in, :feet]
  enum kind: [:temperature, :ultrasound]
  enum type_of_graph: [:line_graph, :bar_graph, :on_off]


end
