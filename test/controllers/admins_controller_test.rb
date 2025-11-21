require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = admins(:alice)

    ApplicationController.any_instance.stubs(:current_user).returns(@admin)
  end

  test 'should delete admin' do
    delete admin_path(@admin)

    assert_redirected_to root_path
    assert_equal '退会しました', flash[:notice]
    assert_nil Admin.find_by(id: '@admin.id')
  end
end
