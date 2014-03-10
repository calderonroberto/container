class SubscriptionsController < ApplicationController

  before_filter :signed_in_display
  
  respond_to :js

  def create
    @app = App.find(params[:subscription][:app_id])
    @app.subscribe!(current_display)
    broadcast_state(current_display) #broadcast state change
    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'subscriptions', method: 'create', display_id: current_display.id, app_id: @app.id, params: params, remote_ip: request.remote_ip )
    end
    respond_with @app
  end

  def destroy
    subscription = Subscription.find(params[:id])
    @display = subscription.display
    @app = subscription.app
    @app.unsubscribe!(@display)
    broadcast_state(current_display) #broadcast state change
    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'subscriptions', method: 'destroy', display_id: @display.id, app_id: @app.id, params: params, remote_ip: request.remote_ip )
    end
    respond_with @app
  end

end
