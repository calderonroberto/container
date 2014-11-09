class UsersController < ApplicationController
 
 before_filter :only => [:index, :profile] do |c| c.signed_in_user params[:id], params[:display_name] end 

 def index
   @display_id = cookies[:display_id]
   @display = Display.find_by_unique_id(@display_id)
   @user = User.find_by_id(cookies[:user_id])

   users = User.where('users.id != ?', cookies[:user_id]).where(:test_group => @user.test_group).joins(:registrations).where('registrations.display_id' => @display_id) #in this model display_id refers to the display_id pervasive in this app, which is actually display_unique_id.; Also, only show people in the same test group (for research purposes)

   @userlist = []
   users.each do |u|     
     usr = {user: u, checkins_count: u.checkins.where("display_id", @display.id).count, checkin_today: u.checkins.where("display_id = ? AND created_at >= ?", @display.id, Time.zone.now.beginning_of_day) }
     @userlist << usr
   end

puts @userlist
   #@userlist.sort_by! { |hash| -hash['score']['score'] }

   #log_usage
   if (Container::Application.config.log_usage)
     Log.create(controller: 'users', method: 'index', user_id: @user.id, display_id: @display_id, params: params, remote_ip: request.remote_ip)
   end
   render :layout => 'mobile'
 end

 def profile
   @user = User.find_by_id(cookies[:user_id])
   @display = Display.find_by_unique_id(cookies[:display_id])
   @display_id = cookies[:display_id]

   winners = LastWeekWinners.get_winners(@display) 
   @is_a_winner = winners.detect {|u| u['user'][:id] == @user.id}.present?

   @checkin_today = @user.checkins.where("display_id = ? AND created_at >= ?", @display.id, Time.zone.now.beginning_of_day)

   @gifts = @user.gifts
   @favours = Favour.where("to_id = ? AND reciprocated = ?", @user.id, false)

   #log_usage
   if (Container::Application.config.log_usage)
     Log.create(controller: 'users', method: 'profile', user_id: @user.id, display_id: @display_id, params: params, remote_ip: request.remote_ip)
   end
   render :layout => 'mobile'
 end 

 def currentuser
   @user = User.find_by_id(cookies[:user_id])
   render json: @user
 end


end
