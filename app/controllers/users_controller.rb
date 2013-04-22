class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      #Handle a successful save
      # Note that we can omit the user_url in the redirect, 
      # writing simply redirect_to @user to redirect to the user show page
      redirect_to @user 
    else
      render 'new'
    end
  end
end
