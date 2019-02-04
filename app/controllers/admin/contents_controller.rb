class Admin::ContentsController < AdminController
  before_action :find_content, only: [:edit, :update, :destroy]
  
  def index
    @contents = Content.all
  end

  def new
    @content = Content.new
  end

  def create
    @content = Content.new(content_params)
    if @content.save
      redirect_to admin_contents_path, alert: "Content Created"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @content.update_attributes(content_params)
      redirect_to admin_contents_path, alert: "Content Updated"
    else
      render 'edit'
    end
  end

  def destroy
    @content.destroy
    redirect_to admin_contents_path, alert: "Content Destroyed"
  end

  def delete_image_attachment
    @image = ActiveStorage::Attachment.find(params[:id])
    @image.purge
    redirect_to request.referrer
  end

  private
  def content_params
    params.require(:content).permit(:name, :url, :overlay_image, :background_image, :text, :loading_image, :scan_button)
  end

  def find_content
    @content = Content.find params[:id]
  end

end
