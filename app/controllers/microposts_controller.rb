class MicropostsController < ApplicationController
  before_filter :signed_in_user,  only: [:create, :destroy]
  before_filter :correct_user,    only: :destroy

  def index
  end

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private 
    def correct_user
      # we use find_ny_id instead of find because find raises an exception when the micropost doesn't exits
      # in that case, use "rescue redirect_to root_url" 
      # finy_by_id will return nil
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_url unless current_user?(@micropost.user)
    end
end
