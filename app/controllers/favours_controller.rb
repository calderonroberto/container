class FavoursController < ApplicationController

  #This causes lots of issues when testing with rspec + Omniauth facebook. Since
  #I'm running out of time for the experiment I'll just leave it open (prototype)
  #before_filter :only => [:show] do |c| c.signed_in_user params[:id] end 

  respond_to :js

  def create 
    user = User.find_by_id(params[:favour][:user_id])
    display = Display.find_by_unique_id(params[:favour][:display_id])
    fromuser = User.find_by_id(params[:favour][:from_id])


    if Favour.where(from_id: fromuser.id).last.nil? then
      @favour = Favour.new(from_id: fromuser.id, to_id: user.id).save
    else
      @favour = Favour.where(from_id: fromuser.id).last
      if ( @favour. created_at <= Time.zone.now.beginning_of_day) then 
         @favour = Favour.new(from_id: fromuser.id, to_id: user.id).save
      end

    end
     
    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'favours', method: 'create', user_id: user.id, display_id: display.id, params: params, remote_ip: request.remote_ip)
    end
    respond_with @favour #so that create.js.rb runs, changing the button to gray
  end


  respond_to :js
  def reciprocate
    @favour =  Favour.find(params[:favour][:favour_id])
    @favour.update_attributes(reciprocated: true)

    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'favours', method: 'reciprocate', params: params, remote_ip: request.remote_ip)
    end
    respond_with @favour #so that create.js.rb runs, changing the button to gray

  end

end





