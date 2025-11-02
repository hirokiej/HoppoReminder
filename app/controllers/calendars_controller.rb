class CalendarsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json do
        schedules = fetch_google_calendar_events(current_user)
        render json: schedules.map { |schedule|
          {
            id: schedule[:google_event_id],
            title: schedule[:summary],
            start: schedule[:start].iso8601
          }
        }
      end
    end
  end
end
