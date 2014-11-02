class ScoresController < ApplicationController

  def show

    time_now = Time.zone.now
    time_beginning_of_week = Time.zone.now.beginning_of_week
    time_beginning_of_last_week = Time.zone.now.beginning_of_week-7.days

    display = Display.find_by_unique_id(params[:display_id])
    this_week_leaders = Array.new
    last_week_winners = Array.new

    users = User.where('users.id != ?', '0').joins(:registrations).where('registrations.display_id' => display.unique_id)
    
    users.each do |user|
      #assemble this week hash
      week_user_hash = Hash.new
      week_user_hash["user"] = {id: user.id, name: user.name, thumbnail_url: user.thumbnail_url}
      week_user_hash["score"] = user.score(display,time_beginning_of_week,time_now)
      week_user_hash["score_from_date"] = time_beginning_of_week
      week_user_hash["score_to_date"] = time_now
      this_week_leaders.push(week_user_hash)
      #assemble last week hash
      last_week_user_hash = Hash.new
      last_week_user_hash["user"] = {id: user.id, name: user.name, thumbnail_url: user.thumbnail_url}
      last_week_user_hash["score"] = user.score(display, time_beginning_of_last_week, time_beginning_of_week)
      last_week_user_hash["score_from_date"] = time_beginning_of_last_week
      last_week_user_hash["score_to_date"] = time_beginning_of_week
      if last_week_user_hash["score"]["score"] > 0
         last_week_winners.push(last_week_user_hash)
      end
    end
    #this_week_leaders.sort_by! { |hash| -hash['week_total_score'] }
    this_week_leaders.sort_by! { |hash| -hash['score']['score'] }
    last_week_winners.sort_by! { |hash| -hash['score']['score'] }

    @response = {display_setup: display.setup ,display_week_score: display.score(time_beginning_of_week, time_now), this_week_leaders: this_week_leaders.take(6), last_week_winners: last_week_winners.take(3)}    
    render json: @response
  end



end
