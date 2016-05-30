class UsersController < ApplicationController

layout "dashboard"

  def new
    @users = User.new
  end

  def create
    user_values = user_params.merge(api_key: User.generate_api)
    @users = User.new user_values

    if @users.save
      session[:user_id] = @users.id
      redirect_to sensors_path, notice: 'Created user'
    else
      render action: 'new'
    end
    # respond_to do |format|
    #   if @users.save
    #
    #     UserMailer.welcome_email(@users).deliver_now
    #
    #     format.html { redirect_to(new_session_path(@users),
    #             notice: 'User was successfully created.') }
    #     format.json { render json: @users, status: :created, location: @users }
    #   else
    #     format.html { render action: 'new' }
    #     format.json { render json: @users.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  def edit
    @user = current_user
  end

  def show
  end


  def update
    @user = User.find params[:id]

    if @user.update(user_params)

      redirect_to sensors_path(current_user), notice: "The user has been successfully updated!"
    end
  end



  private

  def user_params
    params.require(:user).
    permit(:username,
           :email,
           :password,
           :password_confirmation,
           :phone_number)
  end
end
