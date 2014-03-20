# encoding: utf-8
class Admin::HeadersController < Admin::BaseController
  load_and_authorize_resource :class => "Header"
  respond_to :html, :text

  def index
    @search = Header.search(params[:search])
    @headers = @search.relation.page(params[:page]).per_page(50)
  end

  def show
    @header = Header.find(params[:id])
  end

  def new
    @header = Header.new(type: params[:type])
  end

  def edit
    @header = Header.find(params[:id])
  end

  def create
    @header = Header.factory(params[:header])
    if @header.save
      redirect_to admin_headers_path, notice: "Landing de catálogo criado com sucesso."
    else
      render action: "new"
    end

  end

  def update
    @header = Header.find(params[:id])
    if @header.update_attributes(params[:header])
      redirect_to admin_headers_path, notice: 'Landing de catálogo atualizado com sucesso.'
    else
      render action: "edit"
    end

  end

  def destroy
    @header = Header.find(params[:id])
    @header.destroy
    redirect_to admin_headers_path
  end

end
