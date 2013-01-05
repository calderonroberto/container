class MessagesController < ApplicationController

def new
 @display_id = params[:id]
 @message = Display.find(@display_id).messages.build
 render :layout => 'mobile'
end

def create
  display = Display.find(params[:message][:display_id])
  @display_id = display.id  
  @message = display.messages.build(from: params[:message][:from], message: params[:message][:message])
  if @message.save
    broadcast_state(display)
    redirect_to mobile_path(params[:message][:display_id])
  else  
    render 'new', :layout => 'mobile'
  end
end

end
