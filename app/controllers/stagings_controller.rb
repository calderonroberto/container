class StagingsController < ApplicationController
  
  before_filter :signed_in_display

  respond_to :js

  def create
    @app = App.find(params[:staging][:app_id])
    @display = Display.find(current_display)
    @display.stage!(@app)
    broadcast_state(current_display) #broadcast state change
    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'stagings', method: 'create', display_id: @display.id, app_id: @app.id, params: params, remote_ip: request.remote_ip )
    end
    render json: @app
  end

end
