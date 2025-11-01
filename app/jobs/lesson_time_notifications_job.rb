class LessonTimeNotificationsJob < ApplicationJob
  queue_as :default

  def perform(schedule_id, student_id, messages)
    schedule = Schedule.find(schedule_id)
    student = Student.find(student_id)

    client = Line::Bot::V2::MessagingApi::ApiClient.new(
      channel_access_token: student.admin.line_channel_access_token
    )

    message_templates = {
      notice_now: {
        type: 'text',
        text: "レッスン時間が変更になりました。#{schedule.start_at.strftime('%-m月%-d日%H時%M分')}です。"
      },

      before_lesson: {
        type: 'text',
        text: "レッスンは明日、#{schedule.start_at.strftime('%-m月%-d日%H時%M分')}からあります。"
      },

      no_lesson_tomorrow: {
        type: 'text',
        text: '明日はお休みです。'
      }
    }

    message = message_templates[messages.to_sym]
    client.push_message(push_message_request: { to: student.line_user_id, messages: [ message ] })
  end
end
