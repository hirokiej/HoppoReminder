class Students::SchedulesController < ApplicationController
  def show
    @student = current_user.students.find(params[:id])
    @schedules = @student.schedules.where('start_at >= ?', Time.current).order(:start_at)
  end
end
