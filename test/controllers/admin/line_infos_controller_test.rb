require 'test_helper'

class Admin::LineInfosControllerTest < ActionDispatch::IntegrationTest
  test 'should get edit' do
    get admins_line_infos_edit_url
    assert_response :success
  end

  test 'should get update' do
    get admins_line_infos_update_url
    assert_response :success
  end
end
