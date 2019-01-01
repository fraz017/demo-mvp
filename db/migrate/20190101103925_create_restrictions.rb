class CreateRestrictions < ActiveRecord::Migration[5.2]
  def change
    create_table :restrictions do |t|
      t.integer :limit
      t.string :unit

      t.timestamps
    end
  end
end
