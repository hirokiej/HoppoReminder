require 'test_helper'

class Admin::LineInfosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = admins(:alice)

    ApplicationController.any_instance.stubs(:current_user).returns(@admin)
  end

  test 'should get line_info edit page' do
    get line_info_admin_path(@admin)

    assert_response :success
  end

  test 'should update line_infos' do
    patch line_info_admin_path(@admin), params: {
      admin: { line_channel_id: 123456789, line_channel_secret: 123456789, line_channel_access_token: 123456789 }
    }

    assert_redirected_to schedules_path
  end

  test 'should not update line_infos' do
    patch line_info_admin_path(@admin), params: {
      admin: { line_channel_id: 123456789, line_channel_secret: '', line_channel_access_token: '' }
    }

    assert_redirected_to line_info_admin_path(@admin)
  end
end
