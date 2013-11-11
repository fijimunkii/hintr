class CreatePicturesTable < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :url
      t.integer :user_id
      t.integer :num_likes

      t.timestamps
    end
  end
end
