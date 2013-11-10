Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['HINTR_FACEBOOK_KEY'], ENV['HINTR_FACEBOOK_SECRET']
end
