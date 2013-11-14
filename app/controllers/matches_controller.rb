class MatchesController < ApplicationController
  respond_to :json

  def index
    user = current_user

    matches = Match.where(user_id: params[:user_id])
    matches = matches.sort_by { |match| match.weight }.reverse

    locations = matches.map { |match| match.location }.uniq

    matches = [user.max_weight, matches, locations]

    respond_with matches
  end

  def remove_match
    match = Match.find params[:id]
    match.is_removed = true
    match.save

    response = 'removed'
    respond_with response
  end

end
