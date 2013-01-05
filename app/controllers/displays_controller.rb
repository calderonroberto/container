class DisplaysController < ApplicationController

  def new
    @display = Display.new
  end

  def create
    @display = Display.new(params[:display])
    if @display.save
      sign_in @display
      redirect_to root_url
    else
      render 'new'
    end
  end

end
