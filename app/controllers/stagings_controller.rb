class StagingsController < ApplicationController
  
  before_filter :signed_in_display

  respond_to :js

  def create
    @app = App.find(params[:staging][:app_id])
    @display = Display.find(current_display).stage!(@app)
    broadcast_state(current_display) #broadcast state change
    render json: @app
  end

end
