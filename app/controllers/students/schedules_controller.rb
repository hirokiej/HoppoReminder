class Students::SchedulesController < ApplicationController
  def show
    @student = Student.find(params[:id])
  end
end
