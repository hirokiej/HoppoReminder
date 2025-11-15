class SessionsController < ApplicationController
  skip_before_action :check_logged_in, only: :create

  def create
    admin = Admin.find_or_create_from_auth_hash(auth_hash)
    return redirect_to root_path, alert: 'ログインに失敗しました' unless admin

    admin.update_google_tokens(auth_hash)
    log_in admin

    redirect_to(
      admin.line_channel_id.blank? ?
      line_info_admin_path(admin) :
      schedules_path,
      notice: 'ログインしました'
    )
  end

  def destroy
    log_out
    redirect_to root_path, notice: 'ログアウトしました'
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
