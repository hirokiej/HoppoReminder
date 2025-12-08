module Admin::LineInfosHelper
  def has_line_info?(user)
    user.line_channel_id.present? ||
    user.line_channel_access_token.present? ||
    user.line_channel_secret.present?
  end
end
