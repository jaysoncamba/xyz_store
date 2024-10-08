class CreateAuthors < ActiveRecord::Migration[7.1]
  def up
    create_table :authors do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :middle_name
    end
  end

  def down
    drop_table :authors
  end
end
