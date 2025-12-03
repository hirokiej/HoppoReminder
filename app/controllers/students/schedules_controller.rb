class Students::SchedulesController < ApplicationController
  include Authenticatable

  TWO_MONTHS = 8
  def show
    @student = current_user.students.find(params[:id])
    @schedules = @student.schedules.where('start_at >= ?', Time.current).order(:start_at).limit(TWO_MONTHS)
  end
end
