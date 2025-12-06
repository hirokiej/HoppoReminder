require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect to schedules when logged in' do
    admin = admins(:alice)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    get root_path

    assert_redirected_to schedules_path
    assert_equal 'aliceでログインしました', flash[:notice]
  end

  test 'should show top page when not logged in' do
    get root_path

    assert_response :success
  end
end
