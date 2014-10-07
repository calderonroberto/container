class UsersController < ApplicationController
 
 before_filter :only => [:index] do |c| c.signed_in_user params[:id], params[:display_name] end 

 def index
   @display_id = cookies[:display_id]
   @user = User.find_by_id(cookies[:user_id])

   @users = User.where('users.id != ?', cookies[:user_id]).where(:test_group => @user.test_group).joins(:registrations).where('registrations.display_id' => @display_id) #in this model display_id refers to the display_id pervasive in this app, which is actually display_unique_id.; Also, only show people in the same test group (for research purposes)

   #log_usage
   if (Container::Application.config.log_usage)
     Log.create(controller: 'users', method: 'index', user_id: @user.id, display_id: @display_id, params: params, remote_ip: request.remote_ip)
   end
   render :layout => 'mobile'
 end

 def currentuser
   @user = User.find_by_id(cookies[:user_id])
   render json: @user
 end


end
