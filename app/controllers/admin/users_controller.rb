class Admin::UsersController < ApplicationController
  layout "admin"
  respond_to :html

  def index
    @users = User.all
    respond_with :admin, @users
  end

  def show
    @user = User.find(params[:id])
    respond_with :admin, @user
  end

  def edit
    @user = User.find(params[:id])
    respond_with :admin, @user
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
    end

    respond_with :admin, @user
  end
end
