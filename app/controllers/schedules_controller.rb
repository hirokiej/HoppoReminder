class SchedulesController < ApplicationController
  include Authenticatable

  before_action :set_schedules, only: :index
  before_action :set_schedule, only: %i[edit update]

  def index
    schedules = Schedule.fetch_google_calendar_events(current_user)
    upcoming_schedules = schedules.select { |schedule| schedule[:start] >= Time.current }
    Schedule.update_lesson_events(upcoming_schedules, current_user)
  end

  def edit;end

  def update
    @schedule.assign_attributes(schedule_params)

    unless @schedule.start_at_changed?
      redirect_to schedules_path, alert: '日時に変更がありません'
      return
    end

    first_start_at = @schedule.start_at_was

    if @schedule.save
      @schedule.update_google_event(current_user)
      @schedule.notification_message(first_start_at)

      redirect_to schedules_path, notice: 'カレンダーの日時を変更し、LINEの投稿予約も完了しました'
    else
      flash[:alert] = '変更できませんでした'
      render :index,  status: :unprocessable_entity
    end
  end

  private

  def schedule_params
    params.expect(schedule: [ :start_at ])
  end

  def set_schedules
    @schedules = Schedule.where(student: current_user.students).display_lessons
  end

  def set_schedule
    @schedule = Schedule.find(params[:id])
  end
end
