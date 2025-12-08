require 'test_helper'

class LineWebhookControllerTest < ActionDispatch::IntegrationTest
  EVENT = {
    'events' => [
      {
        'type' => 'message',
        'source' => {
          'type' => 'user',
          'userId' => 'daveId'
        },
        'message' => {
          'type' => 'text',
          'text' => 'hello, world'
        }
      }
    ]
  }

  setup do
    @admin = admins(:alice)

    LineWebhookController.any_instance.stubs(:valid_signature?).returns(true)
    LineWebhookController.any_instance.stubs(:fetch_display_name).returns('Dave')
  end

  def post_callback
    post line_webhook_callback_path,
    params: EVENT.to_json,
    headers: {
      'Content-Type' => 'application/json',
      'X-Line-Signature' => 'dummy'
    }
  end

  test 'create student from LINE webhook' do
    assert_difference('@admin.students.count', 1) { post_callback }
  end

  test 'student has correct display_name' do
    post_callback
    student = @admin.students.last

    assert_equal 'Dave', student.line_display_name
  end

  test 'student has correct line_user_id' do
    post_callback
    student = @admin.students.last

    assert_equal 'daveId', student.line_user_id
  end

  test 'responce is 200 ok' do
    post_callback

    assert_response :ok
  end
end
