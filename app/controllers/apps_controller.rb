class AppsController < ApplicationController

  before_filter  :signed_in_display, :only => [:new, :create, :edit, :update, :destroy]
  
  def new
    @setup = current_display.setup
    @app = App.new
    render :layout => 'admin' 
  end

  def create
     @setup = current_display.setup
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
    @setup = current_display.setup
    @app = App.find_by_id(params[:id])
    render :layout => 'admin'
  end

  def update
    @app = App.find_by_id(params[:id])
    if @app.update_attributes(params[:app])
      check_uploads(@app, params)
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

  private
    def check_uploads (app, params)
      if params[:app][:url_uploaded]
        @app[:url] = @app.url_uploaded.url.split('?')[0]        
      end
      if params[:app][:mobile_url_uploaded]
        @app[:mobile_url] = @app.mobile_url_uploaded.url.split('?')[0]
      end
      if params[:app][:thumbnail_url_uploaded].present?
        @app[:thumbnail_url] = @app.thumbnail_url_uploaded.url.split('?')[0]
      end 
      @app.save
    end


end
