class SessionsController < ApplicationController

  def new
    # render "./sessions/new.html.erb"
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user][:username], params[:user][:password])
    # @user = User.find_by_credentials(**session_params)
    if @user
      session[:session_token] = @user.reset_session_token!
      redirect_to cats_url
    else
      flash.now[:errors] = ["Your username or password is wrong you dummy"]
      render :new
    end
  end

  def destroy
    if current_user
      current_user.reset_session_token!
      @current_user = nil
      session[:sesion_token] = nil
    end
  end


  # def session_params
  #   test = params.require(:user).permit(:username, :password)
  #   return {username: test[:username], password: test[:password]}
  # end

end