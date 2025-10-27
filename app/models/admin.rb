class Admin < ApplicationRecord
  encrypts :google_token
  encrypts :google_refresh_token
  encrypts :email, deterministic: true
  encrypts :line_channel_secret
  encrypts :line_channel_access_token

  class << self
    def find_or_create_from_auth_hash(auth_hash)
      admin_params = admin_params_from_auth_hash(auth_hash)
      find_or_create_by(email: admin_params[:email]) do |admin|
        admin.update(admin_params)
      end
    end

    private

    def admin_params_from_auth_hash(auth_hash)
      {
        name: auth_hash.info.name,
        email: auth_hash.info.email
      }
    end
  end
end
