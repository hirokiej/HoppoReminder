require 'test_helper'

class Students::SchedulesControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get students_schedules_show_url

    assert_response :success
  end
end
