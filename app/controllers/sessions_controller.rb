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
    params[:user].delete(:password) if params[:user][:password].blank?
    if @user.update_attributes(params[:user])
      flash[:success] = "Edit Successful."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end
end
