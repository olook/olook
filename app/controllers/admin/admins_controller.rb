# -*- encoding : utf-8 -*-
class Admin::AdminsController < Admin::BaseController

  load_and_authorize_resource

  respond_to :html

  def index
    @admins = Admin.find(:all, :order => 'role_id ASC')
  end

  def show
    @admin = Admin.find(params[:id])
    respond_with :admin, @admin
  end

  def new
    @admin = Admin.new
    respond_with :admin, @admin
  end

  def edit
    @admin = Admin.find(params[:id])
    respond_with :admin, @admin
  end

  def create
    @admin = Admin.new(params[:admin])
      if @admin.save
        flash[:notice] = 'Admin was successfully created.'
      end
    respond_with :admin, @admin
  end

  def update
    @admin = Admin.find(params[:id])
    if params[:admin][:password].blank?
      if @admin.update_without_password(params[:admin])
        flash[:notice] = 'Admin was successfully updated.'
      end
    else
      if @admin.update_attributes(params[:admin])
        flash[:notice] = 'Admin was successfully updated.'
      end
    end
    respond_with :admin,@admin
  end

  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy
    respond_with :admin, @admin
  end


end
