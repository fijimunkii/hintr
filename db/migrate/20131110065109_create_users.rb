class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :fb_id
      t.string :email
      t.string :name
      t.string :gender
      t.string :interested_in
      t.string :relationship_status
      t.string :location
      t.string :profile_picture
      t.date :date_of_birth
      t.string :oauth_token
      t.datetime :oauth_expires_at
      t.boolean :watched_intro, :default => false
      t.integer :max_weight, :default => 0
      t.integer :num_friends, :default => 0
      t.integer :friends_processed, :default => 0

      t.timestamps
    end
  end
end
