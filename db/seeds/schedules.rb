DEFAULT_LESSON_WEEKS = 12
DEFAULT_START_HOUR = 15
CALCULATE_WEEKDAY = 5
CALCULATE_LESSON_TIME = 3
WEEK_START = :monday

students = Student.all

today = Time.zone.today
students.each_with_index do |student, i|
  weekday = i % CALCULATE_WEEKDAY
  start_hour = DEFAULT_START_HOUR + (i % CALCULATE_LESSON_TIME)

  DEFAULT_LESSON_WEEKS.times do |w|
    lesson_day = today.beginning_of_week(WEEK_START) + weekday.days + w.weeks
    start_at = lesson_day.to_time.change(hour: start_hour)

    Schedule.create!(
      student: student,
      google_event_id: "#{student.id}_#{w}",
      start_at: start_at,
      summary: "#{student.real_name}のレッスン"
    )
  end
end
