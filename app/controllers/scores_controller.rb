class ScoresController < ApplicationController


  def show

    # [{ place:"0", user:{id, name}, week_score:{score:"0", checkins:"", gifts:"", place:""} },{...}]
    display = Display.find_by_unique_id(params[:display_id])
    @response = Array.new
    #users = User.all
    users = User.where('users.id != ?', '0').joins(:registrations).where('registrations.display_id' => display.unique_id)
    users.each do |user|
      user_hash = Hash.new
      user_hash["user"] = {id: user.id, name: user.name, thumbnail_url: user.thumbnail_url} 
      if (display.setup.experimental_setup == 0)
      	 user_hash["week_total_score"]= user.week_score["score"]
         user_hash["week_scores"] = {score: user.week_score["score"],
				  checkins: user.week_score["checkins"],
				  gifts: user.week_score["gifts"]}
      elsif (display.setup.experimental_setup == 1)
         if user.week_score["checkins"] > 0
            user_hash["week_total_score"]= user.week_score["score"] + display.week_score["score"]
         else 
	    user_hash["week_total_score"]= user.week_score["score"]
         end
         user_hash["week_scores"] = {score: user.week_score["score"],
				  checkins: user.week_score["checkins"],
				  gifts: user.week_score["gifts"],
				  place: display.week_score["score"]}
      end
      @response.push(user_hash) #assemble response      
    end

    @response.sort_by! { |hash| -hash['week_total_score']  }

    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'scores', method: 'show', display_id: display.id, params: params, remote_ip: request.remote_ip )
    end
    render json: @response.take(9)
  end

  def lastweekwinners
    @response = Array.new
    display = Display.find_by_unique_id(params[:display_id])
    users = User.where('users.id != ?', '0').joins(:registrations).where('registrations.display_id' => display.unique_id)  

    if display.setup.experimental_setup == 1 
      lastweek_place_score = Checkin.where("display_id = ? AND created_at >= ? AND created_at <= ?", display.id, Time.zone.now.beginning_of_week-7.days, Time.zone.now.beginning_of_week).count
    else 
      lastweek_place_score = 0
    end

    users.each do |user|
        user_hash = Hash.new
        user_hash["user"] = {id: user.id, name: user.name, thumbnail_url: user.thumbnail_url} 
        lastweek_checkins= Checkin.where("user_id = ? AND created_at >= ? AND created_at <= ?", user.id, Time.zone.now.beginning_of_week-7.days, Time.zone.now.beginning_of_week).count
        lastweek_gifts = Gift.where("user_id = ? AND created_at >= ? AND created_at <= ?", user.id, Time.zone.now.beginning_of_week-7.days, Time.zone.now.beginning_of_week).count    
        if lastweek_checkins > 0 
          user_hash["lastweek_score"]= lastweek_place_score + lastweek_checkins + lastweek_gifts
          user_hash["lastweek_place_score"]= lastweek_place_score
          user_hash["lastweek_checkins"]= lastweek_checkins
          user_hash["lastweek_gifts"]= lastweek_gifts
	  user_hash["week-from"] = Time.zone.now.beginning_of_week-7.days
	  user_hash["week-to"] =  Time.zone.now.beginning_of_week

        else
	  user_hash["lastweek_score"]= lastweek_gifts
        end

        @response.push(user_hash)
    end

    @response.sort_by! { |hash| -hash['lastweek_score']  }

    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'scores', method: 'winners', display_id: display.id, params: params, remote_ip: request.remote_ip )
    end
    render json:@response.take(3)

  end 


end
