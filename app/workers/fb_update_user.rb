class FBupdateUser
  @queue = :scraper_queue
  def self.perform(user_id, friend_id)
    user = user.find(user_id)
    user.fb_update_user(friend_id)
  end
end
