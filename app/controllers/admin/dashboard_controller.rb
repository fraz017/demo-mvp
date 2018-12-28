class Admin::DashboardController < AdminController
  def index
    views = TrackView.where( created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).group("DATE_PART('hour', created_at)").count
    @labels = ["00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00",
              "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"]
    @data = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    views.each do |k, v|
      date = "#{sprintf '%02d', k.to_i}:00"
      index = @labels.index(date)
      @data[index] = v
    end
  end
end
