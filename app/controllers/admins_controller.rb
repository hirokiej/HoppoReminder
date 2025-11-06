class AdminsController < ApplicationController
  def destroy
    admin = Admin.find(params[:id])
    admin.destroy
    redirect_to root_path, notice: '退会しました'
  end
end
