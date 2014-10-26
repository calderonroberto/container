class SetupsController < ApplicationController

  before_filter  :signed_in_display
  
  def edit
    @setup = Setup.find_by_id(params[:id])
    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'setups', method: 'edit', params: params, remote_ip: request.remote_ip )
    end
    render :layout => 'admin'
  end

  def update
    @setup = Setup.find_by_id(params[:id])
    #log_usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'setups', method: 'update', params: params, remote_ip: request.remote_ip )
    end
    if params[:is_global]
       if Setup.update_all(:thingbroker_url => params[:setup][:thingbroker_url], :interact_instructions => params[:setup][:interact_instructions], :experimental_setup => params[:setup][:experimental_setup])
         flash[:success] = "All Display's Setup updated"
         redirect_to admin_path
       else
         render 'edit'
       end
    elsif @setup.update_attributes(params[:setup])
       flash[:success] = "Setup updated"
       redirect_to admin_path
    else
       render 'edit'
    end
  end

end
