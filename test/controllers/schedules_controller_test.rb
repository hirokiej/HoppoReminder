require 'test_helper'

class SchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = admins(:alice)
    @student = students(:student_bob)
    @schedule = schedules(:bob_first_schedule)

    ApplicationController.any_instance.stubs(:current_user).returns(@admin)

    SchedulesController.any_instance.stubs(:update_google_event)
    SchedulesController.any_instance.stubs(:notification_message)
    SchedulesController.any_instance.stubs(:fetch_google_calendar_events).returns(
      [
        {
          id: 'bob_lesson1_id',
          start: Time.current,
          summary: 'ボブのレッスン'
        }
      ]
    )
  end

  test 'should get edit' do
    get edit_schedule_path(@schedule)

    assert_response :success
  end

  test 'should update schedule' do
    new_date = @schedule.start_at + 3.days
    patch schedule_path(@schedule), params: {
      schedule: { start_at: new_date }
     }

    assert_redirected_to schedules_path
  end
end
