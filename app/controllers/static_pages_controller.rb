class StaticPagesController < ApplicationController

  before_filter  :signed_in_display, only: [:home]
 
  def home
    #@qrcodeurl = "http://magic.ubc.ca"
    @qrcodeurl = "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/mobile/#{current_display.id}"
    render layout: 'home'
  end

  def welcome
    render layout: 'welcome'
  end

end
