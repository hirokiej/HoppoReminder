class Admin::LineInfosController < ApplicationController
  def edit
    @admin = current_user
  end

  def update
    @admin = current_user

    if @admin.update(line_info_params)
      redirect_to schedules_path, notice: 'LINE情報を更新しました'
    else
      flash.now[:alert] = '全ての情報を入力してください'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def line_info_params
    params.require(:admin).permit(:line_channel_id, :line_channel_access_token, :line_channel_secret)
  end
end
