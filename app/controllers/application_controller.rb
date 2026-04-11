class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  helper NavigationHelper
  helper_method :current_user

  def current_user
    return unless (admin_id = session[:admin_id])

    @current_user ||= Admin.find_by(id: admin_id)
  end

  def log_in(admin)
    session[:admin_id] = admin.id
    session.options[:expire_after] = 30.days
  end

  def log_out
    session.delete(:admin_id)
    @current_user = nil
  end
end
