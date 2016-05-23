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

  def edit
    @user = current_user
  end

  def show


    redirect_to edit_user
  end

  private

  def user_params
    params.require(:user).
    permit(:username,
           :password,
           :password_confirmation)
  end
end
