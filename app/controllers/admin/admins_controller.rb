# -*- encoding : utf-8 -*-
class Admin::AdminsController < Admin::BaseController
  respond_to :html

  #load_and_authorize_resource

  def index
    @admins = Admin.all
  end

  def show
    @admin = Admin.find(params[:id])
    respond_with :admin, @admin
  end

  def new
    @admin = Admin.new
    @admin.build_role
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
      if @admin.update_without_password(params[:admin])
        flash[:notice] = 'Admin was successfully updated.'
      end
    respond_with :admin,@admin
  end

  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy
    respond_with :admin, @admin
  end


end
