class CreateLikesTable < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :fb_id
      t.string :name

      t.timestamps
    end
  end
end
