# encoding: utf-8
class Admin::SeoLinksController < Admin::BaseController
  load_and_authorize_resource
  respond_to :html
  def index
    @seo_links = SeoLink.order(:name)
  end

  def show
    @seo_link = SeoLink.find(params[:id])
    respond_with :admin, @seo_link
  end

  def new
    @seo_link = SeoLink.new
    respond_with :admin, @seo_link
  end

  def edit
    @seo_link = SeoLink.find(params[:id])
    respond_with :admin, @seo_link
  end

  def create
    @seo_link = SeoLink.new(params[:seo_link])

    if @seo_link.save
      flash[:notice] = 'Link foi criado com sucesso.'
    end
    respond_with :admin, @seo_link
  end

  def update
    @seo_link = SeoLink.find(params[:id])
    flash[:notice] = 'Link foi atualizado com sucesso.' if @seo_link.update_attributes(params[:seo_link])
    respond_with :admin, @seo_link
  end

  def destroy
    @seo_link = SeoLink.find(params[:id])
    @seo_link.destroy
    flash[:notice] = 'link destruído com sucesso.'
    respond_with :admin, @seo_link
  end
end
