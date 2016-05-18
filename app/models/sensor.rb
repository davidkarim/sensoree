class Sensor < ActiveRecord::Base
  belongs_to :user
  has_many :events
  has_many :notifications

  enum unit: [:Celsius, :Fahrenheit, :cm, :in, :feet, ]
  enum kind: [:temperature, :ultrasound]
  enum type_of_graph: [:bar_graph1, :bar_graph2, :on_off]
  
end
