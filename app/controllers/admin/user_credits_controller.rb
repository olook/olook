class Admin::UserCreditsController < Admin::BaseController
  #TODO: Implement it after payment refactoring...
  def index
    flash[:notice] = "Wating for the payment refactoring to be implemented..."
    redirect_to admin_credits_path
  end
end