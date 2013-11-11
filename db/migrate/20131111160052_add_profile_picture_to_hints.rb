class AddProfilePictureToHints < ActiveRecord::Migration
  def change
    add_column :hints, :profile_picture, :string
  end
end
