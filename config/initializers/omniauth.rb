Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer, :fields => [:name, :email]
end

OmniAuth.config.logger = Rails.logger