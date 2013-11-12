class UserMailer < ActionMailer::Base
  default :from => "the.hintr@gmail.com"

  def registration_confirmation(user)
    binding.pry
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail to: user.email, subject: "Welcome to Hintr!"
  end
end
