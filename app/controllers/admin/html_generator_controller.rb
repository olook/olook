# encoding: UTF-8
class Admin::HtmlGeneratorController < Admin::BaseController
  authorize_resource :class => false
  respond_to :html, :pdf

  def index
  end

  def create
    file = params[:file]
    generate file
  end

  private
    def generate csv_file 
      list = []

      CSV.foreach(csv_file.path, headers: false, col_sep: ';') do |row|
        list << row
      end

      Resque.enqueue(ProductsListGeneratorWorker, list, current_admin.email)
    end


end
