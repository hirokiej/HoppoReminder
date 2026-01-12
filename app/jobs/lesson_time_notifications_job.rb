class LessonTimeNotificationsJob < ApplicationJob
  queue_as :default

  def perform(schedule_id, student_id, timing)
    schedule = Schedule.find(schedule_id)
    student = Student.find(student_id)

    client = Line::Bot::V2::MessagingApi::ApiClient.new(
      channel_access_token: student.admin.line_channel_access_token
    )

    message = message_templates(schedule)[timing.to_sym]
    client.push_message(push_message_request: { to: student.line_user_id, messages: [ message ] })
  end

  private

  def message_templates(schedule)
    start_time = I18n.l(schedule.start_at, format: :with_weekday)

    {
      notice_now: {
        type: 'text',
        text: "レッスン時間が変更になりました。#{start_time}です。"
      },

      before_lesson: {
        type: 'text',
        text: "レッスンは明日、#{start_time}からあります。"
      },

      no_lesson_tomorrow: {
        type: 'text',
        text: '明日はお休みです。'
      }
    }
  end
end
