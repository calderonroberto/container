class GiftsController < ApplicationController

  #This causes lots of issues when testing with rspec + Omniauth facebook. Since
  #I'm running out of time for the experiment I'll just leave it open (prototype)
  #before_filter :only => [:show] do |c| c.signed_in_user params[:id] end 

  respond_to :js

  def create 
    user = User.find_by_id(params[:gift][:user_id])
    display = Display.find_by_unique_id(params[:gift][:display_id])
    fromuser = User.find_by_id(params[:gift][:from_id])
    gift_type = params[:commit]


    if user.gifts.where(from_id: fromuser.id).last.nil? then 
      @gift = user.gift!(fromuser, gift_type)
    else 
      @gift = user.gifts.where(from_id: fromuser.id).last
      if ( @gift. created_at <= Time.zone.now.beginning_of_day) then 
         @gift = user.gift!(fromuser, gift_type)
      end

    end
    
    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'gifts', method: 'create', user_id: user.id, display_id: display.id, params: params, remote_ip: request.remote_ip)
    end
    respond_with @gift #so that create.js.rb runs, changing the button to gray
  end

end





