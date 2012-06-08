class Admin::MomentsController < Admin::BaseController

  load_and_authorize_resource

  respond_to :html, :text

  def index
    @search = Moment.search(params[:search])
    @moments = @search.relation.page(params[:page]).per_page(15).order('created_at desc')
  end

  def show
    @moment = Moment.find(params[:id])
    respond_with :admin, @moment
  end

  def new
    @moment = Moment.new
    respond_with :admin, @moment
  end

  def edit
    @moment = Moment.find(params[:id])
    respond_with :admin, @moment
  end

  def create
    generate_slug(params[:moment]["name"])
    @moment = Moment.new(params[:moment])

    if @moment.save
      flash[:notice] = 'Moment page was successfully created.'
    end
    respond_with :admin, @moment
  end

  def update
    generate_slug(params[:moment]["name"])
    @moment = Moment.find(params[:id])

    if @moment.update_attributes(params[:moment])
      flash[:notice] = 'Moment page was successfully updated.'
    end
    respond_with :admin, @moment
  end

  def destroy
    @moment = Moment.find(params[:id])
    @moment.destroy
    respond_with :admin, @moment
  end

  private

  def generate_slug(name)
    params[:moment]["slug"] = name.parameterize unless params[:moment]["name"].nil?
  end

end
