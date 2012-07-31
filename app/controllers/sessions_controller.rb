class SessionsController < ApplicationController
  
  def new
  end

  def create
  user = User.find_by_name(params[:session][:name])
  if user && user.authenticate(params[:session][:password])
    session[:user] = user
    redirect_to blackjack_path
  else
    flash.now[:error] = 'Invalid email/password combination'
      render 'new'
  end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
  
end
