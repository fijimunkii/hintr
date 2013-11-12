class MatchesController < ApplicationController
  respond_to :json

  def index
    @matches = Match.where(user_id: params[:user_id])
    respond_with @matches
  end

end
