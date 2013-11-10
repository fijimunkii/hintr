class UsersController < ApplicationController

  def oauth_failure
    flash[:error] = 'There was an issue connecting to facebook..'
    redirect_to :root
  end

end
