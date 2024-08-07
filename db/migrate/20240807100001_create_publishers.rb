class CreatePublishers < ActiveRecord::Migration[7.1]
  def up
    create_table :publishers do |t|
      t.string :name, null: false
    end
  end

  def down
    drop_table :publishers
  end
end
