class AnalyticsController < ApplicationController


  def show
    # [{ user:{id, name},data:{messages_sent, checkins}, links[{user_id,messages_sent, messages_received,reciprocity_ratio},{...}] }, {...}]
    display = Display.find_by_unique_id(params[:display_id])
    @response = Array.new
    #users = User.all
    users = User.where('users.id != ?', '0').joins(:registrations).where('registrations.display_id' => display.unique_id)
    users.each do |user|
      user_hash = Hash.new
      user_hash["user"] = {id: user.id, name: user.name, thumbnail_url: user.thumbnail_url}
      user_hash["data"] = {messages_sent: Message.where(from: user.id).count, checkins: Checkin.where("user_id = ? AND display_id = ?", user.id, display.id).count}
      user_hash["links"] = Array.new
      User.where('id != ?',user.id).each do |u|
        messages_sent = Message.where(from: user.id, to: u.id).count
        messages_received = Message.where(from: u.id, to: user.id).count
        if (messages_sent > 0 and messages_received > 0) then
          link = Hash.new
          link["user_id"] = u.id
	  link["messages_sent"] = messages_sent
	  link["messages_received"] = messages_received
	  link["reciprocity_ratio"] = messages_sent/messages_received #divide by zero if no message sent
	  user_hash["links"].push(link)
        end
      end
      @response.push(user_hash) #assemble response      
    end

    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'analytics', method: 'show', display_id: display.id, params: params, remote_ip: request.remote_ip )
    end
    render json: @response
  end

end


