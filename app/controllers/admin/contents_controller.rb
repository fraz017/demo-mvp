class Admin::ContentsController < AdminController
  load_and_authorize_resource
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
      user = User.find(content_params[:user_ids].to_i)
      @content.users << user if current_user.sub? && content_params[:user_ids].present? && !@content.users.include?(user)
      Redirect.bulk_update_fuzzy_text
      redirect_to admin_contents_path, alert: "Content Created"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @content.update_attributes(content_params)
      Redirect.bulk_update_fuzzy_text
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
    params.require(:content).permit(:name, :overlay_image, :background_image, :loading_image, :scan_button, :user_ids, redirects_attributes: [:id, :text, :url, :_destroy])
  end

  def find_content
    @content = Content.find params[:id]
  end

end
