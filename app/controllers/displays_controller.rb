class DisplaysController < ApplicationController

  def new
    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'displays', method: 'new', params: params, remote_ip: request.remote_ip )
    end
    @display = Display.new
  end

  def create
    @display = Display.new(params[:display])
    @display.build_setup
    if @display.save
      sign_in @display
      #log_usage
      if (Container::Application.config.log_usage)
        Log.create(controller: 'displays', method: 'create', display_id: @display.id, params: params, remote_ip: request.remote_ip)
      end
      redirect_to root_url
    else
      render 'new'
    end
  end

end
