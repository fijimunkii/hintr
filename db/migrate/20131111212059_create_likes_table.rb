class CreateLikesTable < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :match_id
      t.string :fb_id
      t.string :type

      t.timestamps
    end
  end
end
