class SessionsController < ApplicationController

  def create
    # queries the OmniAuth login and
    # stores the user_id in the session
    user = User.from_omniauth(env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    # clears the session
    session[:user_id] = nil
    redirect_to root_url
  end

end
