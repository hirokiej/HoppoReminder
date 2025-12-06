require 'test_helper'
require 'minitest/mock'

class ScheduleTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @student = students(:student_bob)
    @schedules = @student.schedules
  end

  test 'should start_today' do
    yesterday = Schedule.create!(
      student: @student,
      summary: '昨日のレッスン',
      google_event_id: 'yesterday_lesson',
      start_at: Time.current - 1.day
    )

    tomorrow = Schedule.create!(
      student: @student,
      summary: '明日のレッスン',
      google_event_id: 'tomorrow_lesson',
      start_at: Time.current + 1.day
    )

    upcoming_schedules = Schedule.start_today

    assert_includes upcoming_schedules, tomorrow
    refute_includes upcoming_schedules, yesterday
  end

  test 'should dispaly limited upcoming lessons' do
    limited_upcoming_schedules = @schedules.limited_upcoming_lessons

    assert_equal 8, limited_upcoming_schedules.count
  end

  test 'should update google event' do
    lesson = schedules(:bob_first_schedule)

    google_mock = Minitest::Mock.new
    google_mock.expect(:update_event, true, [ 'primary', lesson.google_event_id, Google::Apis::CalendarV3::Event ])

    Schedule.stub(:google_calendar_service_for, google_mock) do
      lesson.update_google_event(lesson.student.admin)
    end

    google_mock.verify
  end

  test 'should notificate messages' do
    schedule = schedules(:bob_first_schedule)
    first_start_at = schedule.start_at + 3.days

    schedule.notification_message(first_start_at)

    assert_enqueued_jobs 2
  end
end
