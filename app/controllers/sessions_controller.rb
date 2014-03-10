
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

  def createuser
    #render 'newuser', :layout=> 'usersessions'
    render 'newuser', :layout=> 'usersessions'
  end

  def destroyuser
    sign_out_user
    redirect_to signinuser_path
  end


end

