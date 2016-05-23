class SessionsController < ApplicationController
  layout "session"


  def new
  end

  def create
    @user = User.
            find_by(username: params[:username])
            try(:authenticate, params[:password])

    return render action: 'new' unless @user

    session[:user_id] = @user.id
    redirect_to sensors_path
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Email/Password was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end
end
