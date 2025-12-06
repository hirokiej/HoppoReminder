require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  setup do
    @student = students(:student_bob)
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
end
