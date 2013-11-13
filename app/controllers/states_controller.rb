class StatesController < ApplicationController

  before_filter :signed_in_display, :only => [:state]
  
  respond_to :js

  def state
    @state = get_state    
    render json: @state
  end

  def statedisplay
    @state = DisplayState.get_state(params[:display_id]) 
    render json: @state
  end    
 
end
