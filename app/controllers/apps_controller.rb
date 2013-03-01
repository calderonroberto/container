class AppsController < ApplicationController

  before_filter  :signed_in_display, :only => [:new, :create, :edit, :update, :destroy]
  
  def new
    @app = App.new
    render :layout => 'admin' 
  end

  def create
     @app = App.new(params[:app])
     if @app.save
       @app.subscribe!(current_display)
       flash[:success] = "Yaaay! App Created and Subscribed to."       
       redirect_to admin_path
     else
       render 'new',  :layout => 'admin'
     end
  end

  def edit
    @app = App.find_by_id(params[:id])
    render :layout => 'admin'
  end

  def update
    @app = App.find_by_id(params[:id])
    if @app.update_attributes(params[:app])
      flash[:success] = "App updated"
      redirect_to admin_path
    else
      render 'edit'
    end
  end

  def destroy
    App.find(params[:id]).destroy
    flash[:success] = "App destroyed"
    redirect_to admin_path
  end

  def apps
    @apps = App.all
    render json: @apps
  end


end
