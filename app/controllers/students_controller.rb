class StudentsController < ApplicationController
  def index
  end

  def bulk_update
    if current_user.update(user_params)
      redirect_to students_path, notice: '名前を変更しました'
    else
      render students_path, alert: '名前を変更できませんでした'
    end
  end

  private

  def user_params
    params.require(:admin).permit(students_attributes: [ :id, :real_name ])
  end
end
