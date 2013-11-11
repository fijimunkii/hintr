class ChangeHintFbIdToString < ActiveRecord::Migration
  def change
    remove_column :hints, :fb_id
    add_column :hints, :fb_id, :string
  end
end
