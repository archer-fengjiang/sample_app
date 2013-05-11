class UsersController < ApplicationController

  # by default, before filters apply to every action in a controller
  # so we restrict the filter to act only on :edit and :update actions
  before_filter :signed_in_user,  
                only: [:index, :edit, :update, :destroy, :show, :following, :followers]
  before_filter :correct_user,    only: [:edit, :update]
  before_filter :admin_user,      only: :destroy
  before_filter :new_user,        only: [:new, :create]

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page] )
  end

  # called when going to /users url
  def new
    @user = User.new
  end

  # called when click "create my account" button
  def create
    @user = User.new(params[:user])
    if @user.save
      #Handle a successful save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      # Handle a sucessful update
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    # @users = User.all
    # User.paginate pulls the users out of database one chunk at a time
    # will_paginate will auto generate params[:page]
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    def correct_user
      @user = User.find(params[:id])
      #redirect_to(root_path) unless current_user?(@user)
      if not current_user?(@user)
        redirect_to(root_path)
      end
    end

    def admin_user
      if !current_user.admin? or current_user?(User.find(params[:id]))
        redirect_to(root_path)
      end
    end

    # only not-signed-in user can create new user
    def new_user
      if signed_in?
        redirect_to(root_path)
      end
    end
end