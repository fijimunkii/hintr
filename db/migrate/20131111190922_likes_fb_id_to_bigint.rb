class LikesFbIdToBigint < ActiveRecord::Migration
  def change
    remove_column :likes, :fb_id
    add_column :likes, :fb_id, :string
  end
end
