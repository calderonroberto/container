class MobileController < ApplicationController

before_filter :only => [:index, :show] do |c| c.signed_in_user params[:id], params[:display_name] end 

def index
 if params[:display_name].present?
   @display = Display.find_by_name(params[:display_name])
 else
   @display = Display.find_by_unique_id(params[:id])
 end
 @apps = @display.apps
 cookies[:display_id] = @display.unique_id
 session[:display_id] = @display.unique_id #cookies not accessible in controller below, using session instead (leaving cookies to not break other parts of app)
 @display_id = @display.unique_id

 @user = User.find_by_id(cookies[:user_id])
 @checkin_today = @user.checkins.where("display_id = ? AND created_at >= ?", @display.id, Time.zone.now.beginning_of_day)
 Registration.create(user_id: @user.id, display_id: @display_id) #register that this user has visited this display

 #log usage
 if (Container::Application.config.log_usage)
   Log.create(controller: 'mobile', method: 'index', user_id: @user.id, display_id: @display_id, params: params, remote_ip: request.remote_ip )
 end
 #render :layout => 'mobile' #TODO: for experiment we are redirecting
 
 logger.debug ">>>>>>>>>>>>>>>>>NOTE: redirecting mobile controller (app selection) to Profile for PhD experiment"

 redirect_to profile_url

end

def show
 @app = App.find_by_id(params[:app_id])
 @display_id = cookies[:display_id]
 @display = Display.find_by_unique_id(@display_id)
 @display.stage!(@app)
 @display_id_param = @display_id.to_query("display_id")
 @thingbroker_url_param = @display.setup[:thingbroker_url].to_query("thingbroker_url")
 @user = User.find_by_id(cookies[:user_id])
 #TODO: results in a "undefined method `unique_id' for nil:NilClass in faye_broadcaster worker.
 #broadcast_state(@display_id)

 #log_usage
 if (Container::Application.config.log_usage)
   Log.create(controller: 'mobile', method: 'index', user_id: @user.id, display_id: @display_id, app_id: @app.id, params: params, remote_ip: request.remote_ip )
 end
 render :layout => 'mobile'
end

end
