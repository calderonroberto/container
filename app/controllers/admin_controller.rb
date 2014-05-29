class AdminController < ApplicationController

  before_filter :signed_in_display
  def home
    @app = App.new
    @display = current_display
    @apps = App.paginate(page: params[:page], per_page: 10)
    @setup = @display.setup
    @publicurl = "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/content/#{current_display.unique_id}"
    @setup = Setup.find_by_id(@display.id)

    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'admin', method: 'home', display_id: @display.id, params: params, remote_ip: request.remote_ip )
    end

    render :layout => 'admin'
  end

end

