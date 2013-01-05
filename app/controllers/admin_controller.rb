class AdminController < ApplicationController

  before_filter :signed_in_display
  def home
    @app = App.new
    @display = current_display
    @apps = App.paginate(page: params[:page], per_page: 10)
    render :layout => 'admin'
  end

end

