class ChangeUsersUidToString < ActiveRecord::Migration
  def change
    remove_column :users, :uid
    add_column :users, :uid, :string
  end
end
