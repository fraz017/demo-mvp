class Admin::RestrictionsController < AdminController
  authorize_resource
  before_action :find_content, only: [:edit, :update, :destroy]
  
  def index
    @restrictions = Restriction.all
  end

  def new
    @restriction = Restriction.new
  end

  def create
    @restriction = Restriction.new(restriction_params)
    if @restriction.save
      redirect_to admin_restrictions_path, alert: "Restriction Created"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @restriction.update_attributes(restriction_params)
      redirect_to admin_restrictions_path, alert: "Restriction Updated"
    else 
      render 'edit'
    end
  end

  def destroy
    @restriction.destroy
    redirect_to admin_restrictions_path, alert: "Restriction Destroyed"
  end

  private
  def restriction_params
    params.require(:restriction).permit(:limit, :unit, :content_id)
  end

  def find_content
    @restriction = Restriction.find params[:id]
  end

end
