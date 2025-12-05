require 'line/bot'

class LineWebhookController < ApplicationController
  include Authenticatable

  protect_from_forgery with: :null_session
  skip_before_action :check_logged_in, only: [ :callback ]

  def callback
    body, signature, events = parse_webhook_request

    @bot_admin = find_bot_admin_by_signature(body, signature)
    return head :unauthorized unless @bot_admin

    process_line_events_for_student(events)

    head :ok
  end

  private

  def parse_webhook_request
    body = request.body.read
    signature = request.headers['X-Line-Signature']
    events = JSON.parse(body)['events']

    [ body, signature, events ]
  end

  def client
    @client ||= Line::Bot::V2::MessagingApi::ApiClient.new(channel_access_token: @bot_admin.line_channel_access_token)
  end

  def find_bot_admin_by_signature(body, signature)
    Admin.find_each do |admin|
      return admin if valid_signature?(body, signature, admin.line_channel_secret)
    end
    nil
  end

  def valid_signature?(body, signature, line_channel_secret)
    hash = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA256.new, line_channel_secret, body)
    Base64.strict_encode64(hash) == signature
  end

  def process_line_events_for_student(events)
    events.each do |event|
      line_user_id = event.dig('source', 'userId')
      create_student_from_profile(line_user_id)
    end
  end

  def fetch_display_name(line_user_id)
    profile = client.get_profile(user_id: line_user_id)
    profile.display_name
  end

  def create_student_from_profile(line_user_id)
    return if @bot_admin.students.exists?(line_user_id: line_user_id)

    line_display_name = fetch_display_name(line_user_id)

    @bot_admin.students.create(line_user_id: line_user_id, line_display_name: line_display_name, real_name: line_display_name)
  end
end
