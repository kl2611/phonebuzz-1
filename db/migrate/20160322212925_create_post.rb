class CreatePost < ActiveRecord::Migration
  def up
    create_table :posts do |t|
        t.text :phone, null: false
        t.integer :delay
        t.integer :fizzbuzz

        t.timestamps null: false
    end
  end

  def down
    drop_table :posts
  end
end
