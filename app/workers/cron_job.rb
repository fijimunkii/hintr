class CronJob
  @queue = :cron_queue
  def self.perform

    users = User.where("oauth_token IS NOT NULL")
    users.each do |user|
      user.scrape_facebook
    end

  end
end
