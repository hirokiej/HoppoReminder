class Admin < ApplicationRecord
  has_many :students, dependent: :destroy
  accepts_nested_attributes_for :students

  encrypts :google_token, deterministic: true
  encrypts :google_refresh_token, deterministic: true
  encrypts :email, deterministic: true
  encrypts :line_channel_secret, deterministic: true
  encrypts :line_channel_access_token, deterministic: true

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
