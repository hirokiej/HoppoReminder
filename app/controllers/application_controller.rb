class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include SessionsHelper
  helper NavigationHelper
  helper_method :current_user

  before_action :check_logged_in

  def check_logged_in
    return if current_user

    redirect_to root_path
  end

  private

  def fetch_google_calendar_events(admin)
    calendar_service = google_calendar_service_for(admin)

    response = calendar_service.list_events(
      'primary',
      max_results: 50,
      single_events: true,
      order_by: 'startTime',
      time_min: 1.year.ago.iso8601
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
