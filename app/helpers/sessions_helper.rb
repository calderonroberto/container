module SessionsHelper

  def sign_in(display)
    #hostname = ".#{request.host_with_port}"
    cookies[:display_id] = { :value => nil, :domain => :all }
    cookies[:display_id] = { :value => display.id, :domain => :all }
    cookies.permanent[:remember_token] = display.remember_token
    self.current_display = display
  end

  
  def signed_in?
    !current_display.nil?
  end
  
  def sign_out
    #hostname = ".#{request.host_with_port}"
    cookies.delete :display_id, :domain => :all
    self.current_display = nil
    cookies.delete(:remember_token)
  end
  
  def current_display=(display)
    @display_user = display
  end
  
  def current_display
    @current_display ||= Display.find_by_remember_token(cookies[:remember_token])
  end

  def current_display?(display)
    display == current_display
  end
  
  def signed_in_display
    unless signed_in?
      store_location      
      redirect_to signin_url, notice: "Please sign in."
    end
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end

end
