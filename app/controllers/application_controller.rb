# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  # authenticate :
  # 
  # Checks to see if the user is logged in.
  # If they aren't redirect them to the login page.
  # Also checks to see if they need to reset their password and prevents
  # them from doing any other actions (except ones public to everyone).
  def authenticate
    unless session[:user_id]
      session[:return_to] = request.request_uri
      flash[:error] = "You need to be logged in to access that page."
      redirect_to login_url
    end
  end
  
  # check_admin : 
  # 
  # Checks to see if the current user is
  # an administrator (or higher).
  def check_admin
    authenticate
    unless logged_in_user.role.admin_panel?
      flash[:error] = "You do not have the right permissions to access that part of the site."
      redirect_to root_url
    end
  end
  
  # update_last_seen :
  # 
  # Update's the user's "last seen" ip and time.
  def update_last_seen
    unless session[:user_id].nil?
      logged_in_user.update_attributes({ "last_seen" => Time.now, "last_ip" => request.env['REMOTE_HOST'] })
    end
  end
  
  # logged_in? :
  # 
  # Checks to see if the user is logged in.
  def logged_in?
    !session[:user_id].nil?
  end
  
  # logged_in_user :
  # 
  # Returns the current logged in user.
  def logged_in_user
    unless session[:user_id].nil?
      return User.find(session[:user_id])
    end
  end
end
