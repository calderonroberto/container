module SessionsHelper

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end

  
  ##for users in public displays (managers)
  ##

  def sign_in(display)
    #hostname = ".#{request.host_with_port}"
    cookies[:display_id] = { :value => nil, :domain => :all }
    cookies[:display_id] = { :value => display.unique_id, :domain => :all }
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
  
  ##for users in mobile devices using facebook-connect:
  ##

  def sign_in_user(user)
    cookies.permanent[:user_id] = user.id
    self.current_user = user
    redirect_to '/mobile/'+cookies[:display_id]
  end

  def signed_in_user(display_id)
    cookies[:display_id] = display_id
    unless signed_in_user?
      store_location
      redirect_to signinuser_url, notice: "Please sign in."
    end
  end

  def signed_in_user?
    !current_user.nil?
  end

  def sign_out_user
    #hostname = ".#{request.host_with_port}"
    cookies.delete :user_id, :domain => :all
    self.current_user = nil
    cookies.delete(:user_id)
  end

  def current_user
    @current_user ||= User.find_by_id(cookies[:user_id])
  end

  def current_user=(user)
    @current_user = user
  end


end
