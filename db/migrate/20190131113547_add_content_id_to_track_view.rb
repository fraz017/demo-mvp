class AddContentIdToTrackView < ActiveRecord::Migration[5.2]
  def change
    add_column :track_views, :content_id, :integer
  end
end
