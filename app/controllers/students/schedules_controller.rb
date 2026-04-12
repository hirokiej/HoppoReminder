class Students::SchedulesController < ApplicationController
  include Authenticatable

  def show
    @student = current_user.students.find(params[:id])
    @schedules = @student.schedules.display_lessons
  end
end
