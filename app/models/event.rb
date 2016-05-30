class Event < ActiveRecord::Base
  belongs_to :sensor
  has_many :images
end
