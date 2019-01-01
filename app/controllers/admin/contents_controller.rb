class Admin::ContentsController < AdminController
  before_action :find_content, only: [:edit, :update, :destroy]
  
  def index
    @contents = Content.all
    @restrictions = Restriction.all
  end

  def new
    @content = Content.new
    @restriction = Restriction.new
  end

  def create
    @content = Content.new(content_params)
    if @content.save
      redirect_to admin_contents_path, alert: "Content Created"
    else
      @restriction = Restriction.new
      render 'new'
    end
  end

  def edit
  end

  def update
    if @content.update_attributes(content_params)
      redirect_to admin_contents_path, alert: "Content Updated"
    else
      @restriction = Restriction.last ||= Restriction.new
      render 'edit'
    end
  end

  def destroy
    @content.destroy
    redirect_to admin_contents_path, alert: "Content Destroyed"
  end

  private
  def content_params
    params.require(:content).permit(:name, :url)
  end

  def find_content
    @content = Content.find params[:id]
    @restriction = Restriction.last ||= Restriction.new
  end

end
