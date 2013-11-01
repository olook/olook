# -*- encoding : utf-8 -*-
class Admin::ResellersController < Admin::BaseController

  load_and_authorize_resource

  respond_to :html

  def index
    @search = User.where(reseller: true).search(params[:search])
    @resellers = @search.relation.page(params[:page]).per_page(15).order('created_at desc')    
  end
  def show
    
  end
  def edit
    @reseller = Reseller.find(params[:id])
    respond_with :admin, @reseller
  end

  
  def update
    @reseller = Reseller.find(params[:id])
    if @reseller.update_attributes(params[:reseller])
      flash[:notice] = 'Cadastro do revendedor atualizado.'
    end
    respond_with :admin, @reseller
  end

end
