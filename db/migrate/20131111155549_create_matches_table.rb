class CreateMatchesTable < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :user_a_id
      t.integer :user_b_id
      t.integer :weight
      t.string :name
      t.string :profile_picture

      t.timestamps
    end
  end
end
