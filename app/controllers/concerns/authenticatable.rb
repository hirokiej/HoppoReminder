module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :check_logged_in, except: :mock_login
  end

  def check_logged_in
    return if current_user

    redirect_to root_path, alert: 'ログインに失敗しました'
  end

  def mock_login
    admin = Admin.find_by(name: 'ピアノの先生')
    if admin
      session[:admin_id] = admin.id
      redirect_to schedules_path, notice: 'モックでログインしました'
    end
  end
end
