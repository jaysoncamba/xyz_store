class CreateBookAuthors < ActiveRecord::Migration[7.1]
  def up
    create_table :book_authors do |t|
      t.references :book, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: true
    end
  end

  def down
    drop_table :book_authors
  end
end
