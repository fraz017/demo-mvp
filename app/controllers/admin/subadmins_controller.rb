class Admin::SubadminsController < AdminController
  authorize_resource :user
  before_action :authenticate_user!
  before_action :find_user, only: [:edit, :update, :destroy]

  def index
    @users = User.where(role: 1)
  end

  def new
    @subadmin = User.new
  end

  def create
    @subadmin = User.new(user_params)
    @subadmin
    if @subadmin.save
      redirect_to admin_subadmins_path, alert: "User Created"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @subadmin.update_attributes(user_params)
      redirect_to admin_subadmins_path, alert: "User Updated"
    else
      render 'edit'
    end
  end

  def destroy
    @subadmin.destroy
    redirect_to admin_subadmins_path, alert: "User Destroyed"
  end


  private

  def user_params
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    params.require(:user).permit(:password, :password_confirmation, :email, :role, :redirect_count, :page_count, :content_ids)
  end

  def find_user
    @subadmin = User.find params[:id]
  end
end