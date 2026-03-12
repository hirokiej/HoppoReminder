class LessonTimeNotificationsJob < ApplicationJob
  queue_as :default

  def perform(schedule_id, student_id, timing, first_start_at = nil)
    schedule = Schedule.find(schedule_id)
    student = Student.find(student_id)

    client = Line::Bot::V2::MessagingApi::ApiClient.new(
      channel_access_token: student.admin.line_channel_access_token
    )

    message = message_templates(schedule, first_start_at)[timing.to_sym]
    client.push_message(push_message_request: { to: student.line_user_id, messages: [ message ] })
  end

  private

  def message_templates(schedule, first_start_at)
    start_time = format_time(schedule.start_at)
    old_start_time = format_time(first_start_at) if first_start_at.present?

    {
      notice_now: {
        type: 'text',
        text: "レッスンの日程が変更になりました。\n変更前：#{old_start_time}\n変更後：#{start_time}"
      },

      before_lesson: {
        type: 'text',
        text: "レッスンは、#{start_time}からです。"
      },

      no_lesson_tomorrow: {
        type: 'text',
        text: '明日のレッスンはありません。'
      }
    }
  end

  def format_time(time)
    I18n.l(time, format: :with_weekday)
  end
end
