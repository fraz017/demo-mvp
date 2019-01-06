class Admin::DashboardController < AdminController
  def index
    views = TrackView.group_by_hour(:created_at, range: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, time_zone: Time.zone.name, format: "%-l %p").count
    @day = views.keys
    @daydata = views.values
    views = TrackView.group_by_day(:created_at, range: 1.week.ago..Time.zone.now, time_zone: Time.zone.name, format: "%a").count
    @week = views.keys
    @weekdata = views.values
    views = TrackView.group_by_day(:created_at, range: 1.month.ago..Time.zone.now, time_zone: Time.zone.name, format: "%d %b").count
    @month = views.keys
    @monthdata = views.values
    @ids = TrackView.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
  end

  def destroy_data
    TrackView.destroy_all
    redirect_to admin_contents_path, alert: "Data has been reset"
  end
end
