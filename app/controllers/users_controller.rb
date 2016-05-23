class UsersController < ApplicationController
layout "session"

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
  end


  def update
    @user = User.find params[:id]

    if @user.update(user_params)

      redirect_to sensors_path(current_user), notice: "The Email/Password is successfully updated!"
    end
  end



  private

  def user_params
    params.require(:user).
    permit(:username,
           :email,
           :password,
           :password_confirmation)
  end
end
