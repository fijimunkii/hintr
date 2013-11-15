class UsersController < ApplicationController

  def show
    # return the user requested by the modal
    @user = User.find params[:id]
    @pictures = Picture.where(user_id: @user.id)
    @match = Match.where(user_id: current_user.id, related_user_id: @user.id).first
    @likes = Like.where(match_id: @match.id)
    @uniq_likes = @likes.map { |like| like.like_type.titleize }.uniq
    render json: [@user, @pictures, @uniq_likes]
  end

  def oauth_failure
    # on OmniAuth error, create a flash error and redirect to the homepage
    flash[:error] = 'There was an issue connecting to facebook..'
    redirect_to :root
  end

  def set_interest
    # after logging in for the first time:
    # user.interested_in is set
    # process_friends method is called
    @user = current_user
    @user.interested_in = params[:interested_in]
    if @user.interested_in == "both"
      @user.interested_in = ["male", "female"]
    end
    @user.save
    @user.process_friends
    render json: @user
  end

  def latest_match
    # before user.watched_intro is true
    # requests are made to this action
    # returns the latest match added for the current_user
    user = current_user
    load_percentage = 100 * user.friends_processed / user.num_friends
    response = [Match.where(user_id: user.id).last, load_percentage]
    if user.watched_intro
      response = {}
      response['done'] = 'done'
    end
    render json: response
  end

end
