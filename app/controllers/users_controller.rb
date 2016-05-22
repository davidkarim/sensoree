class UsersController < ApplicationController
  def new
    @users = User.new
  end

  def create
    user_values = user_params.merge(api_key: generate_api)
    @users = User.new user_values

    return render action: 'new' unless @users.save

    redirect_to root_path, notice: 'Created user'
  end

  private

  def generate_api
    alpha = ('A'..'Z').to_a
    alphanum = alpha + ('0'..'9').to_a
    api_key = alpha.sample
    19.times do
      api_key += alphanum.sample
    end
    api_key
  end

  def user_params
    params.require(:user).
    permit(:username,
           :password,
           :password_confirmation)
  end
end
