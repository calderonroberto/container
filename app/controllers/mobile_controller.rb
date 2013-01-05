class MobileController < ApplicationController

def index
 @apps = Display.find_by_id(params[:id]).apps
 cookies[:display_id] = nil
 @display_id = cookies[:display_id] = params[:id]
 render :layout => 'mobile'
end

def show
 @app = App.find_by_id(params[:id])
 @display_id = cookies[:display_id]
 @display = Display.find_by_id(@display_id)
 @display.stage!(@app)
 broadcast_state(@display)
 render :layout => 'mobile'
end



end
