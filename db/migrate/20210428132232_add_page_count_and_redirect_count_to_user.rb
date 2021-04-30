class AddPageCountAndRedirectCountToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :redirect_count, :integer, default: 1
    add_column :users, :page_count, :integer, default: 1
  end
end
