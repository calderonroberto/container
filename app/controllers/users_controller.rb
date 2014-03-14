class UsersController < ApplicationController
 
 before_filter :only => [:index] do |c| c.signed_in_user params[:id], params[:display_name] end 

 def index
   @display_id = cookies[:display_id]
   @user = User.find_by_id(cookies[:user_id])
   @users = User.where('id != ?', cookies[:user_id])
   #log_usage
   if (Container::Application.config.log_usage)
     Log.create(controller: 'users', method: 'index', user_id: @user.id, display_id: @display_id, params: params, remote_ip: request.remote_ip)
   end
   render :layout => 'mobile'
 end

end
