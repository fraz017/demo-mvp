class AdminController < ActionController::Base
    before_action :authenticate_user!

    rescue_from CanCan::AccessDenied do |exception|
        respond_to do |format|
        format.json { head :forbidden, content_type: 'text/html' }
        format.html { redirect_to main_app.admin_dashboard_path, alert: exception.message }
        format.js   { head :forbidden, content_type: 'text/html' }
        end
    end

    layout 'admin'
end
