class CheckinsController < ApplicationController

  #This causes lots of issues when testing with rspec + Omniauth facebook. Since
  #I'm running out of time for the experiment I'll just leave it open (prototype)
  #before_filter :only => [:show] do |c| c.signed_in_user params[:id] end 

  respond_to :js

  def create 
    user = User.find_by_id(params[:checkin][:user_id])
    display = Display.find_by_id(params[:checkin][:display_id])
    thingbroker_url = display.setup.thingbroker_url


    if user[:email] == "anonymous@email.com" then 
      @checkin = user.checkin!(display)
      broadcast_checkin(display, user,thingbroker_url)#broadcast checkin to arduino (app/workers/checkin_broadcaster, and /app/helpers/checkins_helper)
    end

    if user.checkins.last.nil? then
      @checkin = user.checkin!(display)
      broadcast_checkin(display, user,thingbroker_url)#broadcast checkin to arduino (app/workers/checkin_broadcaster, and /app/helpers/checkins_helper)
    else
      @checkin = user.checkins.last
      if (@checkin.created_at <= Time.zone.now.beginning_of_day) then
        @checkin = user.checkin!(display)
        broadcast_checkin(display, user,thingbroker_url)#broadcast checkin to arduino (app/workers/checkin_broadcaster, and /app/helpers/checkins_helper)
      end      
    end
    @user = user
    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'checkins', method: 'create', user_id: @user.id, display_id: display.id, params: params, remote_ip: request.remote_ip)
    end
    respond_with @user #so that create.js.rb runs, changing the button to gray
  end

  def show
    @display = Display.find_by_unique_id(params[:id])
    @display_id = params[:id]
    @user = User.find_by_id(cookies[:user_id])
    users = User.where('users.id != ?', '0').joins(:registrations).where('registrations.display_id' => @display_id)
    @userlist = []
    users.each do |u|     
      usr = {user: u, checkins_count: u.checkins.where("display_id", @display.id).count, checkin_today: u.checkins.where("display_id = ? AND created_at >= ?", @display.id, Time.zone.now.beginning_of_day) }
      @userlist << usr
    end
    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'checkins', method: 'show', display_id: @display.id, params: params, remote_ip: request.remote_ip )
    end
   render :layout => 'mobile'
  end

  def displaycheckins
    display = Display.find_by_unique_id(params[:display_id])
    @response = Array.new

    checkins = Checkin.find(:all, :conditions => ["display_id = ?", display.id], :limit => 50, :order => 'created_at desc')
    checkins.each do |checkin|
      checkin_hash = Hash.new
      user = User.find_by_id(checkin.user_id)
      checkin_hash["user"] = {id: user.id, name: user.name}
      checkin_hash["checkin"] = {created_at: checkin.created_at, display_id: checkin.display_id}
      @response.push(checkin_hash)
    end
    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'checkins', method: 'displaycheckins', display_id: display.id, params: params, remote_ip: request.remote_ip )
    end
    render json: @response
  end

end





