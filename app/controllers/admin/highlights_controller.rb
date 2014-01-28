class Admin::HighlightsController <  Admin::BaseController

  load_and_authorize_resource

  respond_to :haml

  def index
    @left_image = Highlight.find_by_position 2
    @center_image = Highlight.find_by_position 1
    @right_image = Highlight.find_by_position 3
  end

  def show
    @highlight = Highlight.find(params[:id])
  end

  def new
    @highlight = Highlight.new
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
