# -*- encoding : utf-8 -*-
class Admin::LandingPagesController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  respond_to :html, :text

  def index
    @landing_pages = LandingPage.all
    respond_with :admin, @landing_pages
  end

  def show
    @landing_page = LandingPage.find(params[:id])
    respond_with :admin, @landing_page
  end

  def new
    @landing_page = LandingPage.new
    respond_with :admin, @landing_page
  end

  def edit
    @landing_page = LandingPage.find(params[:id])
    respond_with :admin, @landing_page
  end

  def create
    @landing_page = LandingPage.new(params[:landing_page])

    if @landing_page.save
      flash[:notice] = 'Landing page was successfully created.'
    end
    respond_with :admin, @landing_page
  end

  def update
    @landing_page = LandingPage.find(params[:id])

    if @landing_page.update_attributes(params[:landing_page])
      flash[:notice] = 'Landing page was successfully updated.'
    end
    respond_with :admin, @landing_page
  end

  def destroy
    @landing_page = LandingPage.find(params[:id])
    @landing_page.destroy
    respond_with :admin, @landing_page
  end

end
