class StaticPagesController < ApplicationController

  before_filter  :signed_in_display, only: [:home]
 
  def home
    @qrcodeurl = "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/mobile/#{current_display.unique_id}"
    if (request.env['SERVER_PORT'] == '80')
      @texturl = "http://#{request.env['SERVER_NAME']}/m/#{current_display.name}"
    else
      @texturl = "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/m/#{current_display.name}"
    end
    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'static_pages', method: 'home', display_id: current_display.id, params: params, remote_ip: request.remote_ip)
    end
    render layout: 'home'
  end

  def welcome
    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'static_pages', method: 'welcome', params: params, remote_ip: request.remote_ip)
    end
    render layout: 'welcome'
  end

end
