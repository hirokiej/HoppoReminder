module SessionsHelper
  def current_user
    return unless (admin_id = session[:admin_id])

    @current_user ||= Admin.find_by(id: admin_id)
  end

  def log_in(admin)
    session[:admin_id] = admin.id
  end

  def log_out
    session.delete(:admin_id)
    @current_user = nil
  end
end
