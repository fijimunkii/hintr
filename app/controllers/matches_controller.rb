class MatchesController < ApplicationController
  respond_to :json

  def index
    user = current_user

    matches = Match.where(user_id: params[:user_id])
    matches = matches.sort_by { |match| match.weight }.reverse

    location_freq = Hash.new(0)

    matches.each do |match|
      if match.location
        location_freq[match.location] += 1
      end
    end

    location_freq = location_freq.sort_by{|k, v| v}.reverse

    locations = location_freq.map { |x, y| "#{x} - #{y}" }

    matches = [user.max_weight, matches, locations]

    respond_with matches
  end

  def remove_match
    match = Match.find params[:id]
    response = match.related_user_id

    if match.user_id == current_user.id
      match.is_removed = true
      match.save
    end

    render json: [response]
  end

end
