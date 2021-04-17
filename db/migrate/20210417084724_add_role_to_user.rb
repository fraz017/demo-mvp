class AddRoleToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :role, :integer, default: 0
    add_column :users, :content_id, :integer
  end
end
