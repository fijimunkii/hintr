class CreateMatchesTable < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :user_id
      t.integer :related_user_id
      t.integer :weight
      t.string :relationship_status
      t.string :location
      t.string :name
      t.string :profile_picture
      t.boolean :is_removed, :default => false

      t.timestamps
    end
  end
end
