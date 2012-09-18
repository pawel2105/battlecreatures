class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  protected

  def current_user=(user)
    session[:current_user_id] = user.try(:id)
  end

  def current_user
    @current_user ||= User.find_by_id(session[:current_user_id])
  end

  def login_required
    return true if current_user
    access_denied
  end

  # Redirect as appropriate when an access request fails.
  #
  # The default action is to redirect to the login screen.
  #
  # Override this method in your controllers if you want to have special
  # behavior in case the admin_user is not authorized
  # to access the requested action.  For example, a popup window might
  # simply close itself.
  def access_denied
    redirect_to '/auth/developer'
    false
  end

end
