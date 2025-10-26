class Admin < ApplicationRecord
  encrypts :google_token
  encrypts :google_refresh_token
  encrypts :email
  encrypts :line_channel_secret
  encrypts :line_channel_access_token
end
