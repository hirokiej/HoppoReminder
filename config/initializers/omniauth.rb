Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Rails.application.credentials.google[:client_id],
           Rails.application.credentials.google[:client_secret],
           scope: 'email,profile,https://www.googleapis.com/auth/calendar',
           access_type: 'offline',
           prompt: 'consent'
end
