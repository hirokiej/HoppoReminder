class ApplicationController < ActionController::Base
  MOCK_ADMIN = 'ピアノの先生'
  MOCK_CALENDAR_EVENTS = [
    { google_event_id: '1', summary: 'テストレッスン１', start: Time.current + 3.days + 15.hours },
    { google_event_id: '2', summary: 'テストレッスン2', start: Time.current + 10.days + 15.hours }
  ]
  GOOGLE_CALENDAR_MAX_RESULTS = 50
  GOOGLE_CALENDAR_LOOKBACK = 1.year.ago
  allow_browser versions: :modern

  include SessionsHelper
  helper NavigationHelper
  helper_method :current_user

  before_action :check_logged_in, except: :mock_login

  def check_logged_in
    return if current_user

    redirect_to root_path, alert: 'ログインに失敗しました'
  end

  def mock_login
    admin = Admin.find_by(name: 'ピアノの先生')
    if admin
      session[:admin_id] = admin.id
      redirect_to schedules_path, notice: 'モックでログインしました'
    end
  end

  private

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
end
