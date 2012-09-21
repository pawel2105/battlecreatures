class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_mxit_user, :send_stats

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

  helper_method :current_user


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

  def send_stats
    if ENV['GA_TRACKING_CODE'] && current_user
      begin
      g = Gabba::Gabba.new(ENV['GA_TRACKING_CODE'], "mxithangmanleague.herokuapp.com")
      if request.env['HTTP_X_DEVICE_USER_AGENT']
        g.user_agent = request.env['HTTP_X_DEVICE_USER_AGENT']
      else
        g.user_agent = request.env['HTTP_USER_AGENT']
      end
      if request.env["HTTP_X_MXIT_PROFILE"]
        profile = MxitProfile.new(request.env["HTTP_X_MXIT_PROFILE"])
        g.utmul = profile.language
        g.set_custom_var(1, 'Gender', profile.gender, 1)
        g.set_custom_var(2, 'Age', profile.age, 1)
      end
      if request.env["HTTP_X_MXIT_LOCATION"]
        location = MxitLocation.new(request.env["HTTP_X_MXIT_LOCATION"])
        g.set_custom_var(3, 'Country', location.country_name, 1)
        g.set_custom_var(4, 'Province', location.principal_subdivision_name, 1)
      end
      current_user.update_attribute(:utma,g.cookie_params(current_user.id)) unless current_user.utma?
      g.identify_user(current_user.utma) if current_user.utma?
      g.page_view("#{params[:controller]} #{params[:action]}", request.fullpath,current_user.id)
      rescue Exception => e
        Rails.logger.error e.message
        # ignore errors
      end
    end
  end

  def load_mxit_user
    if request.env['HTTP_X_MXIT_USERID_R']
      @current_user = User.find_or_create_from_auth_hash(provider: 'mxit',
                                                              uid: request.env['HTTP_X_MXIT_USERID_R'],
                                                             info: { name: request.env['HTTP_X_MXIT_NICK']})
    end
  end

end
