class AddLatitudeAndLongitudeToTrackView < ActiveRecord::Migration[5.2]
  def change
    add_column :track_views, :latitude, :float, default: 0.0
    add_column :track_views, :longitude, :float, default: 0.0
  end
end
