class HelpController < ApplicationController

  def show
    @user = User.find_by_id(cookies[:user_id])
    @display = Display.find_by_unique_id(cookies[:display_id])
    @display_id = cookies[:display_id]
    render :layout => 'mobile'
  end

end
