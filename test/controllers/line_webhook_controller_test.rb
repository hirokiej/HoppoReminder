require 'test_helper'

class LineWebhookControllerTest < ActionDispatch::IntegrationTest
  test 'should get callback' do
    get line_webhook_callback_url

    assert_response :success
  end
end
