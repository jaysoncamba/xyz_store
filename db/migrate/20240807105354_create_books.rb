class CreateBooks < ActiveRecord::Migration[7.1]
  def up
    create_table :books do |t|
      t.string :title, null: false
      t.string :isbn_13, null: false
      t.string :isbn_10
      t.decimal :price, null: false
      t.string :image_url
      t.string :edition
      t.integer :publication_year, null: false
      t.references :publisher, null: false, foreign_key: true
    end
  end
end
