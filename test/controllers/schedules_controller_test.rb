require 'test_helper'

class SchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = admins(:alice)
    @student = students(:student_bob)
    @schedule = schedules(:bob_first_schedule)

    ApplicationController.any_instance.stubs(:current_user).returns(@admin)

    @yesterday_lesson = Schedule.create!(
      student: @student,
      summary: '昨日のレッスン',
      google_event_id: 'yesterday_lesson',
      start_at: Time.current - 1.day
    )

    @tomorrow_lesson = Schedule.create!(
      student: @student,
      summary: '明日のレッスン',
      google_event_id: 'tomorrow_lesson',
      start_at: Time.current + 1.day
    )

    Schedule.any_instance.stubs(:update_google_event)
    Schedule.any_instance.stubs(:notification_message)
    Schedule.stubs(:fetch_google_calendar_events).returns([])
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

  test 'should display only start_today' do
    get schedules_path
    assert_response :success

    upcoming_schedules = @student.schedules.start_today

    assert_includes upcoming_schedules, @tomorrow_lesson
    refute_includes upcoming_schedules, @yesterday_lesson
  end
end
