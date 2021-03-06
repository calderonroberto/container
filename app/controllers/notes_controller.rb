class NotesController < ApplicationController

before_filter :only => [:new] do |c| c.signed_in_user params[:id], params[:display_name] end 

def new
 @display_id = params[:id]
 @user_id = cookies[:user_id]
 @user = User.find_by_id(@user_id)
 @note = Display.find_by_unique_id(@display_id).notes.build
 #log_usage
 if (Container::Application.config.log_usage)
   Log.create(controller: 'notes', method: 'new', user_id: @user.id, display_id: @display_id, params: params, remote_ip: request.remote_ip)
 end
 render :layout => 'mobile'
end

def create
  @user = User.find_by_id(params[:note][:user_id])
  display = Display.find_by_unique_id(params[:note][:display_id])
  @display_id = display.unique_id
  @note = display.notes.build(from: params[:note][:user_id], message: Obscenity.sanitize(params[:note][:message]))
  if @note.save
    #TODO: removed because unkown key "created_at" at faye_broadcaster.rb:9.
    #broadcast_state(display) 
    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'notes', method: 'create', user_id: @user.id, display_id: @display_id, params: params, remote_ip: request.remote_ip)
    end
    redirect_to mobile_path(params[:note][:display_id])
  else  
    render 'new', :layout => 'mobile'
  end
end

end
