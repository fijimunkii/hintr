class CreateHintsTable < ActiveRecord::Migration
  def change
    create_table :hints do |t|
      t.integer :user_id
      t.integer :fb_id, :limit => 8
      t.integer :age
      t.string :name
      t.string :gender
      t.string :interested_in
      t.string :relationship_status
      t.string :location
      t.integer :score

      t.timestamps
    end
  end
end
