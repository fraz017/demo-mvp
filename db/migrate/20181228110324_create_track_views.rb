class CreateTrackViews < ActiveRecord::Migration[5.2]
  def change
    create_table :track_views do |t|
      t.string :device_id

      t.timestamps
    end
  end
end
