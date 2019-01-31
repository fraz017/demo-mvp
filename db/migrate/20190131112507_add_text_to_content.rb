class AddTextToContent < ActiveRecord::Migration[5.2]
  def change
    add_column :contents, :text, :string
  end
end
