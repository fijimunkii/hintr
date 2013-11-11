class ChangeUsersUiDtoBigInt < ActiveRecord::Migration
  def change
    remove_column :users, :uid
    add_column :users, :uid, :bigint
  end
end
