# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
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
