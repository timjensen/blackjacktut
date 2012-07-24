class UsersController < ApplicationController
 
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to "https://www.google.co.nz/"
    else
      render 'new'
    end
  end
  
end
