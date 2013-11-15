class FBupdatePhotos
  @queue = :scraper_queue
  def self.perform(user_id, friend_id)
    user = user.find(user_id)
    user.fb_update_photos(friend_id)
  end
end
