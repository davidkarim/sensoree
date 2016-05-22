class UsersController < ApplicationController
  def new
    @users = User.new
  end

  def create
    # binding.pry
    user_values = user_params.merge(api_key: generate_api)
    @users = User.new user_values

    return render action: 'new' unless @users.save

    redirect_to root_path, notice: 'Created user'
  end

  private

<<<<<<< HEAD
  def generate_api
    alpha = ('A'..'Z').to_a
    alphanum = alpha + ('0'..'9').to_a
    api_key = alpha.sample
    19.times do
      api_key += alphanum.sample
    end
    api_key
  end

=======
>>>>>>> 034f1157be17438826f74315f9973bde1a18a8c6
  def user_params
    params.require(:user).
    permit(:username,
           :password,
           :password_confirmation)
  end
end
