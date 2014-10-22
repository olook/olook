class Admin::HighlightsController <  Admin::BaseController
  load_and_authorize_resource
  respond_to :haml

  def index
   @highlights = Highlight.order(id: :desc)
  end

  def show
    @highlight = Highlight.find(params[:id])
  end

  def new
    @highlight = Highlight.new(position: params["position"])
  end

  def edit
    @highlight = Highlight.find(params[:id])
  end

  def create
    @highlight = Highlight.new(params[:highlight])
    if @highlight.save
      redirect_to [:admin, @highlight], notice: 'Destaque criado com sucesso.'
    else
      render action: "new"
    end
  
  end

  def update
    @highlight = Highlight.find(params[:id])
    if @highlight.update_attributes(params[:highlight])
      redirect_to admin_highlights_path, notice: 'Destaque modificado com sucesso.'
    else
      render action: "edit"
    end

  end

  def destroy
    @highlight = Highlight.find(params[:id])
    @highlight.destroy
    redirect_to admin_highlights_url
  end

end
