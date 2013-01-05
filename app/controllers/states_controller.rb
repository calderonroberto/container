class StatesController < ApplicationController

  before_filter :signed_in_display
  
  respond_to :js

  def state
    @state = get_state
    render json: @state
  end
 
end
