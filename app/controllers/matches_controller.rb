class MatchesController < ApplicationController
  respond_to :json

  def index
    user = current_user
    @matches = Match.where(user_id: params[:user_id])
    @matches = @matches.sort_by { |match| match.weight }.reverse
    @matches = [user.max_weight, @matches]
    respond_with @matches
  end

end
