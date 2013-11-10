Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['HINTR_FACEBOOK_KEY'], ENV['HINTR_FACEBOOK_SECRET']
end

# OmniAuth error handling http://stackoverflow.com/a/11256549/2474735
OmniAuth.config.on_failure = UsersController.action(:oauth_failure)
