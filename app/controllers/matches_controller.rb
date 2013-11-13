class MatchesController < ApplicationController
  respond_to :json

  def index
    user = User.find params[:user_id]
    @matches = Match.where(user_id: params[:user_id])
    @matches.max_weight = user.max_weight
    respond_with @matches
  end

end
