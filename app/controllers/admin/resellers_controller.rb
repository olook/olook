# -*- encoding : utf-8 -*-
class Admin::ResellersController < Admin::BaseController

  load_and_authorize_resource

  respond_to :html

  def index
    @search = Reseller.all_reseller.search(params[:search])
    @reseller = @search.relation.page(params[:page]).per_page(15).order('created_at desc')    
  end
  def show
    
  end
  def edit
    
  end

end
