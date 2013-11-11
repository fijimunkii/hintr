class CreatePicturesTable < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :url
      t.integer :hint_id
      t.integer :num_likes

      t.timestamps
    end
  end
end
