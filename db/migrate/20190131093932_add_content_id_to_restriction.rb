class AddContentIdToRestriction < ActiveRecord::Migration[5.2]
  def change
    add_column :restrictions, :content_id, :integer
  end
end
