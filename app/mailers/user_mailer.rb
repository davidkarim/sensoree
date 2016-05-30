class UserMailer < ApplicationMailer
  default from: 'juan235711@gmail.com'

  def welcome_email(user)
    @users = user
    @url  = 'http://example.com/login'

    mail(to: 'davidkarim@gmail.com',
        subject: 'Welcome to My Awesome Site') do |format|
          format.html { render 'welcome_email' }
          format.text { render text: 'welcome_email' }
    end
  end
end
