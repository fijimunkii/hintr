class UsersController < ApplicationController

  def show
    @user = User.find params[:id]
    render json: @user
  end

  def oauth_failure
    # on OmniAuth error, create a flash error and redirect to the homepage
    flash[:error] = 'There was an issue connecting to facebook..'
    redirect_to :root
  end

  def set_interest
    @user = current_user
    @user.interested_in = params[:interested_in]
    @user.save
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
