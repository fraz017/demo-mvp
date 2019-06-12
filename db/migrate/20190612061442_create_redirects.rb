class CreateRedirects < ActiveRecord::Migration[5.2]
  def change
    create_table :redirects do |t|
      t.string :text
      t.string :url
      t.references :content, foreign_key: true

      t.timestamps
    end
  end
end
