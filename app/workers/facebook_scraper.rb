class FacebookScraper
  @queue = :scraper_queue
  def self.perform(user_id)
    user = User.find(user_id)
    user.scrape_facebook
  end
end
