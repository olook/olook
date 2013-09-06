# -*- encoding : utf-8 -*-
class Admin::RolesController < Admin::BaseController
  respond_to :html

  load_and_authorize_resource

  def index
    @roles = Role.all
  end

  def show
    @role = Role.find(params[:id])
    respond_with :admin, @role
  end

  def copy
    @cloned_role = Role.find(params[:id])
    @role = @cloned_role.dup
    @role.permissions = @cloned_role.permissions.dup
    @permissions = Permission.all
    render :new
  end

  def new
    @role = Role.new
    @permissions = Permission.all
    respond_with :admin, @role
  end

  def edit
    @role = Role.find(params[:id])
    @permissions = Permission.all
    respond_with :admin, @role
  end

  def create
    @role = Role.new(params[:role])
    @permissions = Permission.all
      if @role.save
        flash[:notice] = 'Role was successfully created.'
      end
    respond_with :admin, @role
  end

  def update
    @role = Role.find(params[:id])
      if @role.update_attributes(params[:role])
        flash[:notice] = 'Role was successfully updated.'
      end
    respond_with :admin, @role
  end

  def destroy
    @role = Role.find(params[:id])
    @role.destroy
    respond_with :admin, @role
  end

end
