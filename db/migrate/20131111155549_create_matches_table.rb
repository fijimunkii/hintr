class CreateMatchesTable < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :like_id
      t.integer :user_id
      t.integer :hint_id

      t.timestamps
    end
  end
end
