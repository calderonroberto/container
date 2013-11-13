class SetupsController < ApplicationController

  before_filter  :signed_in_display
  
  def edit
    @setup = Setup.find_by_id(params[:id])
    render :layout => 'admin'
  end

  def update
    @setup = Setup.find_by_id(params[:id])
    if params[:is_global]
       if Setup.update_all(:thingbroker_url => params[:setup][:thingbroker_url])
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
