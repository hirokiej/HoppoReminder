require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  test 'should find or create admin from auth hash' do
    @auth_hash = OmniAuth::AuthHash.new({
      provider: 'google',
      info: {
      name: 'alice',
      email: 'alice@example.com'
      }
    })
    admin = Admin.find_or_create_from_auth_hash(@auth_hash)

    assert_equal 'alice', admin.name
    assert_equal 'alice@example.com', admin.email
  end
end
