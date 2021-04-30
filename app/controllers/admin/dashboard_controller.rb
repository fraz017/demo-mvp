class Admin::DashboardController < AdminController
  def index
    if current_user.super?
      id = Content.where(name: params[:page]).first
      if params[:page].present? && id.present?
        views = TrackView.where(content_id: id.id).group_by_hour(:created_at, range: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, time_zone: Time.zone.name, format: "%-l %p").count
        @today = TrackView.where(content_id: id.id, created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
        @tm = @today.map{|x| {lat: x.latitude, lng: x.longitude}}
        @day = views.keys
        @daydata = views.values
        views = TrackView.where(content_id: id.id).group_by_day(:created_at, range: 1.week.ago..Time.zone.now, time_zone: Time.zone.name, format: "%a").count
        @lastweek = TrackView.where(content_id: id.id, created_at: 1.week.ago..Time.zone.now)
        @wm = @lastweek.map{|x| {lat: x.latitude, lng: x.longitude}}
        @week = views.keys
        @weekdata = views.values
        views = TrackView.where(content_id: id.id).group_by_day(:created_at, range: 1.month.ago..Time.zone.now, time_zone: Time.zone.name, format: "%d %b").count
        @lastmonth = TrackView.where(content_id: id.id, created_at: 1.month.ago..Time.zone.now)
        @mm = @lastmonth.map{|x| {lat: x.latitude, lng: x.longitude}}
        @month = views.keys
        @monthdata = views.values
      else
        @day = []
        @daydata = []
        @week = []
        @weekdata = []
        @month = []
        @monthdata = []
        @today = []
        @lastweek = []
        @lastmonth = []
        @tm =[]
        @wm = []
        @mm = []
      end
    elsif current_user.sub?
      id = current_user.contents.where(name: params[:page]).first
      if id.present?
        views = TrackView.where(content_id: id.id).group_by_hour(:created_at, range: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, time_zone: Time.zone.name, format: "%-l %p").count
        @today = TrackView.where(content_id: id.id, created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
        @tm = @today.map{|x| {lat: x.latitude, lng: x.longitude}}
        @day = views.keys
        @daydata = views.values
        views = TrackView.where(content_id: id.id).group_by_day(:created_at, range: 1.week.ago..Time.zone.now, time_zone: Time.zone.name, format: "%a").count
        @lastweek = TrackView.where(content_id: id.id, created_at: 1.week.ago..Time.zone.now)
        @wm = @lastweek.map{|x| {lat: x.latitude, lng: x.longitude}}
        @week = views.keys
        @weekdata = views.values
        views = TrackView.where(content_id: id.id).group_by_day(:created_at, range: 1.month.ago..Time.zone.now, time_zone: Time.zone.name, format: "%d %b").count
        @lastmonth = TrackView.where(content_id: id.id, created_at: 1.month.ago..Time.zone.now)
        @mm = @lastmonth.map{|x| {lat: x.latitude, lng: x.longitude}}
        @month = views.keys
        @monthdata = views.values
      else
        @day = []
        @daydata = []
        @week = []
        @weekdata = []
        @month = []
        @monthdata = []
        @today = []
        @lastweek = []
        @lastmonth = []
        @tm =[]
        @wm = []
        @mm = []
      end
    end  

  end

  def destroy_data
    TrackView.destroy_all
    redirect_to admin_contents_path, alert: "Data has been reset"
  end
end
