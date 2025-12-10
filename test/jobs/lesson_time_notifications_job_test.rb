require 'test_helper'

class LessonTimeNotificationsJobTest < ActiveJob::TestCase
  setup do
    @schedule = schedules(:bob_first_schedule)
    @student = students(:student_bob)
    @job = LessonTimeNotificationsJob.new
  end

  test 'job is enqueued' do
    assert_enqueued_with(job: LessonTimeNotificationsJob) do
      LessonTimeNotificationsJob.perform_later(@schedule.id, @student.id, :before_lesson)
    end
  end

  test 'message_templates return correct messages' do
    messages = @job.send(:message_templates, @schedule)

    start_time = I18n.l(@schedule.start_at, format: :with_weekday)

    assert_equal "レッスン時間が変更になりました。#{start_time}です。", messages[:notice_now][:text]
    assert_equal "レッスンは明日、#{start_time}からあります。", messages[:before_lesson][:text]
    assert_equal '明日はお休みです。', messages[:no_lesson_tomorrow][:text]
  end
end
