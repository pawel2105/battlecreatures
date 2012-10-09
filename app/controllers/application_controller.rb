class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_mxit_user
  after_filter :send_stats

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  protected

  def current_user
    @current_user ||= User.find_by_id(session[:current_user_id])
  end

  helper_method :current_user

  def login_required
    return true if current_user
    access_denied
  end

  def access_denied
    redirect_to '/auth/developer'
    false
  end

  def send_stats
    if tracking_enabled? && current_user && status != 302
      begin
        Timeout::timeout(15) do
          g = Gabba::Gabba.new(tracking_code, request.host)
          g.user_agent = current_user.user_agent || request.env['HTTP_USER_AGENT']
          g.utmul = current_user.language || "en"
          g.set_custom_var(1, 'Gender', current_user.gender || "unknown", 1)
          g.set_custom_var(2, 'Age', current_user.age || "unknown", 1)
          g.set_custom_var(3, current_user.country || "unknown Country", current_user.area || "unknown", 1)
          g.set_custom_var(5, 'Provider', current_user.provider, 1)
          current_user.update_attribute(:utma, g.cookie_params(current_user.id)) unless current_user.utma?
          g.identify_user(current_user.utma) if current_user.utma?
          g.page_view("#{params[:controller]} #{params[:action]}", request.fullpath,current_user.id)
        end
      rescue Exception => e
        Rails.logger.error e.message
      end
    end
  end

  def load_mxit_user
    Rails.logger.info(request.env.find_all{|key,value| key.include?("X_MXIT") }.inspect) # log mxit headers
    if request.env['HTTP_X_MXIT_USERID_R']
      @current_user = User.find_or_create_from_auth_hash(provider: 'mxit',
                                                              uid: request.env['HTTP_X_MXIT_USERID_R'],
                                                             info: { name: request.env['HTTP_X_MXIT_NICK']})
      if request.env["HTTP_X_MXIT_PROFILE"]
        @mxit_profile = MxitProfile.new(request.env["HTTP_X_MXIT_PROFILE"])
        current_user.age, current_user.gender = @mxit_profile.age, @mxit_profile.gender
      end
      if request.env['HTTP_X_DEVICE_USER_AGENT']
        current_user.user_agent = "Mxit #{request.env['HTTP_X_DEVICE_USER_AGENT']}"
      end
      if request.env["HTTP_X_MXIT_LOCATION"]
        @mxit_location = MxitLocation.new(request.env["HTTP_X_MXIT_LOCATION"])
        current_user.country = @mxit_location.country
        current_user.area = @mxit_location.city
      end
    end
  end

  def tracking_enabled?
    ENV['GA_TRACKING_CODE'].present?
  end

  def tracking_code
    ENV['GA_TRACKING_CODE']
  end

end
