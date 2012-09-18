Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer, :fields => [:name, :email] if Rails.env.development?
end

OmniAuth.config.logger = Rails.logger