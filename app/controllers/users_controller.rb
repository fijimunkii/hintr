class UsersController < ApplicationController

  def oauth_failure
    # on OmniAuth error, create a flash error and redirect to the homepage
    flash[:error] = 'There was an issue connecting to facebook..'
    redirect_to :root
  end

  def scrape
    @user = User.find params[:user_id]
    Resque.enqueue(FacebookScraper, @user.id)
    render json: @user
  end

  def load_hints
    user = User.find params[:user_id]
    matches = Match.where(user_id: user.id)
    render json: matches
  end

  def load_intro
    @user = User.find params[:user_id]
    Resque.enqueue(RegistrationMailer, @user.id)

    intro = "/videos/intro.mp4"
    render json: intro
  end

end
