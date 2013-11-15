class RegistrationFinisher
  @queue = :mailer_queue
  def self.perform(user_id)

    # find the user this task belongs to
    user = User.find(user_id)

    # set a boolean so user can access site
    user.watched_intro = true

    user.save

    # send email notifying that profile is set up
    UserMailer.registration_confirmation(user).deliver

  end
end
