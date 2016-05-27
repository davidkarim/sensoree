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

  def send_email
    email_subject = "TEST"

    message = <<MESSAGE_END
From: Private Person <me@fromdomain.com>
To: A Test User <dkarim@msn.com>
MIME-Version: 1.0
Content-type: text/html
Subject: SMTP e-mail test

This is an e-mail message to be sent in HTML format

<b>This is HTML message.</b>
<h1>This is headline.</h1>
MESSAGE_END
    Net::SMTP.start('localhost') do |smtp|
    smtp.send_message message, 'me@fromdomain.com',
                             'dkarim@msn.com'
    end

  end

end
