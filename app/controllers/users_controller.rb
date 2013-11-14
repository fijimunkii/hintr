class UsersController < ApplicationController

  def show
    @user = User.find params[:id]
    render json: @user

    #TODO include likes where user_id
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
    Resque.enqueue(RegistrationMailer, @user.id)
    render json: @user
  end

  def load_hints
    user = User.find params[:user_id]
    matches = Match.where(user_id: user.id)
    sorted_matches = matches.sort_by{|match| match.weight}.reverse
    render json: sorted_matches
  end

  def latest_match
    user = current_user
    response = Match.where(user_id: user.id).last
    if user.watched_intro
      response = {}
      response['done'] = 'done'
    end
    render json: response
  end

end
