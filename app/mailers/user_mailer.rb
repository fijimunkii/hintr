class UserMailer < ActionMailer::Base
  default :from => "Hintr"

  def registration_confirmation(user)
    @user = user
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail to: user.email, subject: "Welcome to Hintr!"
  end
end
