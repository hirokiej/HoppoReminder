students = Student.all

today = Time.zone.today
weeks = 12
students.each_with_index do |student, i|
  weekday = i % 5
  start_hour = 15 + (i % 3)

  weeks.times do |w|
    lesson_day = today.beginning_of_week(:monday) + weekday.days + w.weeks
    start_at = lesson_day.to_time.change(hour: start_hour)

    Schedule.create!(
      student: student,
      google_event_id: "#{student.id}_#{w}",
      start_at: start_at,
      summary: "#{student.real_name}のレッスン"
    )
  end
end
