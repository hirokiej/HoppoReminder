class StudentsController < ApplicationController
  include Authenticatable

  def index
    @students = current_user.students
  end

  def bulk_update
    @students_form = StudentsForm.new(current_user.students)

    if @students_form.update(students_params)
      redirect_to students_path, notice: '名前を変更しました'
    else
      render students_path, alert: '名前を変更できませんでした'
    end
  end

  private

  def students_params
    params.require(:students).map do |student| {
      id: student['id'],
      real_name: student['real_name']
      }
    end
  end
end
