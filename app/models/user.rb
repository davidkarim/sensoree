class User < ActiveRecord::Base
  has_secure_password
  has_many :sensors
  has_many :notes
end
