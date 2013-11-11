class UsersController < ApplicationController

  def oauth_failure
    # on OmniAuth error, create a flash error and redirect to the homepage
    flash[:error] = 'There was an issue connecting to facebook..'
    redirect_to :root
  end

end
