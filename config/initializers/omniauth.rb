Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
           info_fields: ['name', 'email', 'age_range', 'context'].join(',')
end
