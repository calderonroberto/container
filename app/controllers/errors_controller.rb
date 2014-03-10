class ErrorsController < ApplicationController
  def routing
   #log_usage
   if (Container::Application.config.log_usage)
     Log.create(controller: 'errors', method: 'routing', params: params, remote_ip: request.remote_ip )
   end
   render :file => "#{Rails.root}/public/404", :status => 404, :layout => false
  end
end
