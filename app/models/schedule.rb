class Schedule < ApplicationRecord
  belongs_to :student

  MOCK_ADMIN = 'ピアノの先生'
  MOCK_CALENDAR_EVENTS = [
    { google_event_id: '1', summary: 'テストレッスン１', start: Time.current + 3.days + 15.hours },
    { google_event_id: '2', summary: 'テストレッスン2', start: Time.current + 10.days + 15.hours }
  ]
  GOOGLE_CALENDAR_MAX_RESULTS = 50
  GOOGLE_CALENDAR_LOOKBACK = 1.year.ago

  NOTICE_TIME_BEFORE_LESSON = 1.day
  NOTICE_TIME_NO_LESSON_TOMORROW = 1.day
  NOTICE_HOUR = 20

  TWO_MONTHS = 8

  scope :limited_upcoming_lessons, -> { where('start_at >= ?', Time.current).order(:start_at).limit(TWO_MONTHS) }

  def update_google_event(admin)
    service = self.class.google_calendar_service_for(admin)
    calendar_id = 'primary'

    event_id = google_event_id
    start_at = self.start_at.in_time_zone('Asia/Tokyo').to_datetime
    end_at = start_at + 45.minutes

    event = Google::Apis::CalendarV3::Event.new(
      summary: summary,
      start: Google::Apis::CalendarV3::EventDateTime.new(date_time: start_at, time_zone: 'Asia/Tokyo'),
      end:   Google::Apis::CalendarV3::EventDateTime.new(date_time: end_at, time_zone: 'Asia/Tokyo')
    )

    service.update_event(calendar_id, event_id, event)
  end

  def notification_message(first_start_at)
    notification_time = start_at
    LessonTimeNotificationsJob.perform_now(id, student.id, :notice_now)
    self.enqueue_notification(
      (notification_time - NOTICE_TIME_BEFORE_LESSON).change(hour: NOTICE_HOUR, min: 0),
      :before_lesson
    )
    self.enqueue_notification(
      (first_start_at - NOTICE_TIME_NO_LESSON_TOMORROW).change(hour: NOTICE_HOUR, min: 0),
      :no_lesson_tomorrow
    )
  end

  private

  def enqueue_notification(wait_until, timing)
    LessonTimeNotificationsJob
    .set(wait_until: wait_until)
    .perform_later(id, student.id, timing)
  end

  class << self
    def google_calendar_service_for(admin)
      calendar_service = Google::Apis::CalendarV3::CalendarService.new
      credentials = Google::Auth::UserRefreshCredentials.new(
        client_id: Rails.application.credentials.google[:client_id],
        client_secret: Rails.application.credentials.google[:client_secret],
        scope: [ 'https://www.googleapis.com/auth/calendar' ],
        refresh_token: admin.google_refresh_token
      )
      calendar_service.authorization = credentials
      calendar_service
    end

    def update_lesson_events(events, admin)
      events.each do |event|
        student = Student.identify_from_summary(event, admin.students)

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

    def fetch_google_calendar_events(admin)
      if admin.name == MOCK_ADMIN
        return MOCK_CALENDAR_EVENTS
      end

      calendar_service = google_calendar_service_for(admin)

      response = calendar_service.list_events(
        'primary',
        max_results: GOOGLE_CALENDAR_MAX_RESULTS,
        single_events: true,
        order_by: 'startTime',
        time_min: GOOGLE_CALENDAR_LOOKBACK.iso8601
      )

      response.items.map do |schedule|
        {
          google_event_id: schedule.id,
          summary: schedule.summary,
          start: (schedule.start.date || schedule.start.date_time).to_time
        }
      end
    end
  end
end
