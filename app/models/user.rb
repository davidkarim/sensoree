require 'net/smtp'

class User < ActiveRecord::Base
  has_secure_password
  has_many :sensors
  has_many :notes

  # Used to generate a 20 digit alphanumeric API key
  def self.generate_api
    alpha = ('A'..'Z').to_a
    alphanum = alpha + ('0'..'9').to_a
    api_key = alpha.sample
    19.times do
      api_key += alphanum.sample
    end
    api_key
  end

end
