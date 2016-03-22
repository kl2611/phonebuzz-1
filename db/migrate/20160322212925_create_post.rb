class CreatePost < ActiveRecord::Migration
  def up
    create_table :posts do |t|
        t.integer :phone, null: false
        t.integer :delay, null: false
        t.integer :fizzbuzz, null: false

        t.timestamps null: false
    end
  end

  def down
    drop_table :posts
  end
end
