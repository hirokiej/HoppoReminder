class SchedulesController < ApplicationController
  before_action :set_schedules

  def index
    schedules = fetch_google_calendar_events(current_user)
    update_lesson_events(schedules)
  end

  private

  def update_lesson_events(events)
    events.each do |event|
      student = current_user.students.detect { |f| event[:summary].to_s.include?(f.real_name) }

      if student
        schedule = Schedule.find_or_initialize_by(google_event_id: event[:google_event_id])
        schedule.update!(
          summary: event[:summary],
          start_at: event[:start],
          student: student
        )
      end
    end
  end

  def set_schedules
    @schedules = Schedule.where(student: current_user.students)
  end
end
