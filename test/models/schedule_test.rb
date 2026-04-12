require 'test_helper'
require 'minitest/mock'

class ScheduleTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @admin = admins(:alice)
    @student = students(:student_bob)
    @schedules = @student.schedules
  end

  test 'should display upcoming lessons and last ended lesson' do
    last_ended_lesson = Schedule.create!(
      student: @student,
      summary: 'ボブの昨日のレッスン',
      google_event_id: 'last_ended_lesson',
      start_at: Time.current - 1.day
    )

    second_last_ended_lesson = Schedule.create!(
      student: @student,
      summary: 'ボブの2回前のレッスン',
      google_event_id: 'second_last_ended_lesson',
      start_at: last_ended_lesson.start_at - 1.second
    )

    display_schedules = @student.schedules.display_lessons

    assert_includes display_schedules, last_ended_lesson
    refute_includes display_schedules, second_last_ended_lesson
  end

  test 'should display limited lessons' do
    limited_schedules = @schedules.display_lessons

    assert_operator limited_schedules.count, :<=, Schedule::MAX_UPCOMING_LESSONS + 1
  end

  test 'should order lessons from old to new' do
    bob_schedules = @student.schedules.display_lessons

    assert_equal schedules(:bob_first_schedule), bob_schedules.first
    assert_equal schedules(:bob_fourth_schedule), bob_schedules.last
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

  test 'should be google_calendar_service_for' do
    @admin.google_refresh_token = 'alice_refresh_token'

    service = Schedule.google_calendar_service_for(@admin)

    assert_instance_of Google::Apis::CalendarV3::CalendarService, service
  end

  test 'should update lesson events' do
    dave = Student.create!(
      admin: @admin,
      line_user_id: 'daveid',
      line_display_name: 'Dave',
      real_name: 'デイブ'
    )

    events = [
      { google_event_id: '1', summary: 'デイブのレッスン', start: Time.current + 3.days + 15.hours },
      { google_event_id: '2', summary: 'イブレッスン2', start: Time.current + 10.days + 15.hours }
    ]

    Schedule.update_lesson_events(events, @admin)

    assert Schedule.exists?(google_event_id: '1')
    refute Schedule.exists?(google_event_id: '2')
  end
end
