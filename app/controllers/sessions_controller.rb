class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page
      sign_in user # sign_in function doesn't exist
      redirect_back_or user
    else
      flash[:error] = 'Invalid email/password combination' #not quite right
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end