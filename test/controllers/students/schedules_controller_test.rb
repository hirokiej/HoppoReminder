require 'test_helper'

class Students::SchedulesControllerTest < ActionDispatch::IntegrationTest
  test 'should show right student lessons for total 5' do
    admin = admins(:alice)
    bob = students(:student_bob)

    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    get schedules_student_path(bob)

    assert_response :success

    assert_select 'li', text: /変更/, count: 5
  end
end
