class ApplicationController < ActionController::Base
  protect_from_forgery

private

  # sets the user_id of the logged in user in the session
  # important for querying when the user tries to access stuff
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # calls the current user method for every controller action
  helper_method :current_user

end
