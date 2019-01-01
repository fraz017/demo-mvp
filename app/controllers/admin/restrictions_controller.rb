class Admin::RestrictionsController < AdminController
  before_action :find_content, only: [:edit, :update, :destroy]
  
  def new
    @restriction = Restriction.new
  end

  def create
    @restriction = Restriction.new(restriction_params)
    if @restriction.save
      redirect_to admin_contents_path, alert: "Restriction Created"
    else
      @content = Content.new  
      render 'admin/contents/new'
    end
  end

  def edit
  end

  def update
    if @restriction.update_attributes(restriction_params)
      redirect_to admin_contents_path, alert: "Restriction Updated"
    else
      @content = Content.find params[:id]  
      render 'admin/contents/edit'
    end
  end

  def destroy
    @restriction.destroy
    redirect_to admin_contents_path, alert: "Restriction Destroyed"
  end

  private
  def restriction_params
    params.require(:restriction).permit(:limit, :unit)
  end

  def find_content
    @restriction = Restriction.first ||= Restriction.new
  end

end
