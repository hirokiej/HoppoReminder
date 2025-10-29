class SchedulesController < ApplicationController
  before_action :set_schedules, only: :index
  before_action :set_schedule, only: %i[edit update]

  def index
    schedules = fetch_google_calendar_events(current_user)
    update_lesson_events(schedules)
  end

  def edit;end

  def update
    if @schedule.update(schedule_params)
      update_google_event(@schedule)

      redirect_to schedules_path, notice: '日時を変更しました'
    else
      redirect_to schedules_path, notice: '変更できませんでした'
    end
  end

  private

  def update_google_event(schedule)
    service = google_calendar_service_for(current_user)
    calendar_id = 'primary'

    event_id = schedule.google_event_id
    start_at = schedule.start_at.in_time_zone('Asia/Tokyo').to_datetime
    end_at = start_at + 45.minutes

    event = Google::Apis::CalendarV3::Event.new(
      summary: @schedule.summary,
      start: Google::Apis::CalendarV3::EventDateTime.new(date_time: start_at, time_zone: 'Asia/Tokyo'),
      end:   Google::Apis::CalendarV3::EventDateTime.new(date_time: end_at, time_zone: 'Asia/Tokyo')
    )

    service.update_event(calendar_id, event_id, event)
  end

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

  def schedule_params
    params.require(:schedule).permit(:start_at)
  end

  def set_schedules
    @schedules = Schedule.where(student: current_user.students)
  end

  def set_schedule
    @schedule = Schedule.find(params[:id])
  end
end
