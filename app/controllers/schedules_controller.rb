class SchedulesController < ApplicationController
  NOTICE_TIME_BEFORE_LESSON = 1.day
  NOTICE_TIME_NO_LESSON_TOMORROW = 1.day
  NOTICE_HOUR = 20

  before_action :set_schedules, only: :index
  before_action :set_schedule, only: %i[edit update]

  def index
    schedules = fetch_google_calendar_events(current_user)
    upcoming_schedules = schedules.select { |schedule| schedule[:start] >= Time.current }
    update_lesson_events(upcoming_schedules)

    today = Date.current
    @schedules = @schedules.where('start_at >= ?', Time.current)
  end

  def edit;end

  def update
    first_start_at = @schedule.start_at
    if @schedule.update(schedule_params)
      update_google_event(@schedule)
      notification_message(first_start_at)

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
      student = Student.find_real_name(event, current_user.students)

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
    @schedules = Schedule.where(student: current_user.students).order(:start_at)
  end

  def set_schedule
    @schedule = Schedule.find(params[:id])
  end

  def notification_message(first_start_at)
    notification_time = @schedule.start_at
    LessonTimeNotificationsJob.perform_now(@schedule.id, @schedule.student.id, :notice_now)
    enqueue_notification(
      (notification_time - NOTICE_TIME_BEFORE_LESSON).change(hour: NOTICE_HOUR, min: 0),
      :before_lesson
    )
    enqueue_notification(
      (first_start_at - NOTICE_TIME_NO_LESSON_TOMORROW).change(hour: NOTICE_HOUR, min: 0),
      :no_lesson_tomorrow
    )
  end

  def enqueue_notification(wait_until, type)
    LessonTimeNotificationsJob
    .set(wait_until: wait_until)
    .perform_later(@schedule.id, @schedule.student.id, type)
  end
end
