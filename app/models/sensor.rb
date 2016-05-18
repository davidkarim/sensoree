class Sensor < ActiveRecord::Base
  belongs_to :user
  has_many :events
  has_many :notifications
end
