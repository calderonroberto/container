class StatesController < ApplicationController

  before_filter :signed_in_display, :only => [:state]
  
  respond_to :js

  def state
    @state = get_state    
    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'states', method: 'state', params: params, remote_ip: request.remote_ip )
    end
    render json: @state
  end

  def statedisplay
    display = Display.find_by_unique_id(params[:display_id])
    @state = DisplayState.get_state(display) 
    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'states', method: 'statedisplay', display_id: display.id, params: params, remote_ip: request.remote_ip)
    end
    render json: @state
  end    
 
end
