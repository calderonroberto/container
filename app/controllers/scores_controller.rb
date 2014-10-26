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
    render json: @response
  end



end
