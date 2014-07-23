FACEBOOK_APP_CONFIG = YAML.load_file("#{Rails.root}/config/facebook_app.yml")[Rails.env]
GITHUB_APP_CONFIG   = YAML.load_file("#{Rails.root}/config/github_app.yml")[Rails.env]
LINKEDIN_APP_CONFIG = YAML.load_file("#{Rails.root}/config/linkedin_app.yml")[Rails.env]
GOOGLE_APP_CONFIG = YAML.load_file("#{Rails.root}/config/google_app.yml")[Rails.env]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, FACEBOOK_APP_CONFIG['app_id'], FACEBOOK_APP_CONFIG['app_secret'],
    scope: 'email'#, callback_path: '_auth/facebook/callback'
  provider :github,   GITHUB_APP_CONFIG['app_id'], GITHUB_APP_CONFIG['app_secret']
  provider :linkedin, LINKEDIN_APP_CONFIG['app_id'], LINKEDIN_APP_CONFIG['app_secret']
  provider :google_oauth2, GOOGLE_APP_CONFIG['app_id'], GOOGLE_APP_CONFIG['app_secret']
end
  
OmniAuth.config.logger = Rails.logger
OmniAuth.config.on_failure = SessionsController.action(:oauth_failure)
