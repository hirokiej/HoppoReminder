require 'line/bot'

class LineWebhookController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :check_logged_in, only: [ :callback ]

  def callback
    body = request.body.read
    signature = request.headers['X-Line-Signature']

    @bot_account = find_bot_account_by_signature(body, signature)
    return head :unauthorized unless @bot_account
    events = JSON.parse(body)['events']

    events.each do |event|
      line_user_id = event.dig('source', 'userId')
      handle_follow(line_user_id, client)
    end
    head :ok
  end

  private

  def client
    @client ||= Line::Bot::V2::MessagingApi::ApiClient.new(channel_access_token: @bot_account.line_channel_access_token)
  end

  def find_bot_account_by_signature(body, signature)
    Admin.find_each do |admin|
      if valid_signature?(body, signature, admin.line_channel_secret)
        return admin
      end
    end
    nil
  end

  def valid_signature?(body, signature, line_channel_secret)
    hash = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA256.new, line_channel_secret, body)
    Base64.strict_encode64(hash) == signature
  end

  def handle_follow(line_user_id, client)
    return if @bot_account.students.exists?(line_user_id: line_user_id)

    profile = client.get_profile(user_id: line_user_id)
    line_display_name = profile.display_name

    @bot_account.students.create(line_user_id: line_user_id, line_display_name: line_display_name)
  end
end
