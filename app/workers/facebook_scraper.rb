class FacebookScraper
  @queue = :scraper_queue
  def self.perform(user_id, facebook_id)

    # find the user this task belongs to
    user = User.find(user_id)

    # run the update methods for the friend
    user.fb_update_user(friend_id)
    user.fb_update_match(friend_id)
    user.fb_update_photos(friend_id)

  end
end
