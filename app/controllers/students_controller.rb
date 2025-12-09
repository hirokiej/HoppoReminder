class StudentsController < ApplicationController
  include Authenticatable

  def index
    @students = current_user.students
  end

  def bulk_update
    @students = current_user.students
    @students_form = StudentsForm.new(current_user.students)

    if @students_form.update(students_params)
      redirect_to students_path, notice: '名前を変更しました'
    else
      flash[:alert] = '変更内容を入力してください'
      render 'index',  status: :unprocessable_entity
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
