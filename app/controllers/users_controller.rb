class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user_values = user_params.merge(api_key: generate_api)
    @user = User.new user_values

    return render action: 'new' unless @user.save

    redirect_to root_path, notice: 'Created user'
  end

  def generate_api
    alpha = ('A'..'Z').to_a
    alphanum = alpha + ('0'..'9').to_a
    api_key = alpha.sample
    19.times do
      api_key += alphanum.sample
    end
    api_key
  end

  private
  def user_params
    params.require(:user).
    permit(:username,
           :password,
           :password_confirmation)
  end
end
