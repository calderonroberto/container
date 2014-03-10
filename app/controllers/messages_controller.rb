class MessagesController < ApplicationController
 
 before_filter :only => [:new, :create] do |c| c.signed_in_user params[:id] end 

 def new
   @display_id = params[:id]
   @user = User.find_by_id(cookies[:user_id])
   @user_to_display = User.find_by_id(params[:user_id])
   @messages = Message.where(:to => [@user_to_display.id, @user.id], :from => [@user.id, @user_to_display.id]).order("created_at DESC")

   @message = Message.new
   #log_usage
   if (Container::Application.config.log_usage)
     Log.create(controller: 'messages', method: 'new', user_id: @user.id, display_id: @display_id, params: params, remote_ip: request.remote_ip )
   end
   render :layout => 'mobile'
 end

 def create
   @user = User.find_by_id(cookies[:user_id])
   display = Display.find_by_unique_id(params[:message][:display_id])
   @display_id = display.unique_id
   @message = Message.new(from: params[:message][:from_id], message: params[:message][:message], to: params[:message][:to_id])
   @user_to_display = User.find_by_id(params[:message][:to_id])
   @messages = Message.where(:to => [@user_to_display.id, @user.id]).order("created_at DESC")
   if @message.save 
     @message = Message.new
     #log_usage
     if (Container::Application.config.log_usage)
       Log.create(controller: 'messages', method: 'create', user_id: @user.id, display_id: @display_id, params: params, remote_ip: request.remote_ip)
     end
     render 'new', :layout => 'mobile'
   else
     render 'new', :layout => 'mobile'
   end
 
 end


end
