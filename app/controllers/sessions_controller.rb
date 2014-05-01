
class SessionsController < ApplicationController

  def create
    display = Display.find_by_name(params[:session][:name])
    if display && display.authenticate(params[:session][:password])
      sign_out
      sign_in display
      redirect_back_or root_url #sessions_helper
    else
      flash.now[:error] = "Invalid display/password combination"
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to signin_path
  end
  
  def newuser
    @display = Display.find_by_unique_id(cookies[:display_id]) #to display users of this display
    unless @display.nil?
      #Using sample is innefficient for a large set, but since we expect very little user for our tests we use this for ease of development
      users = User.where('users.id != ?', '0').joins(:registrations).where('registrations.display_id' => @display.unique_id).sample(4) 
    else 
      users = User.find(:all).sample(5)
    end
    @userlist = []
    users.each do |u|     
      usr = {user: u, checkins_count: u.checkins.find(:all).count }
      @userlist << usr
    end
 
    #To render anonymous checkin
    @user = User.find_by_email("anonymous@email.com")

    #log usage
    if (Container::Application.config.log_usage)
      Log.create(controller: 'sessions', method: 'newuser', display_id: @display.unique_id, params: params, remote_ip: request.remote_ip )
    end
    render 'newuser', :layout=> 'usersessions'
  end

  def destroyuser
    sign_out_user
    redirect_to signinuser_path
  end

end

