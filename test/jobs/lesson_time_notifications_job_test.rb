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

    assert_equal "レッスン時間が変更になりました。#{@schedule.start_at.strftime('%-m月%-d日%H時%M分')}です。", messages[:notice_now][:text]
    assert_equal "レッスンは明日、#{@schedule.start_at.strftime('%-m月%-d日%H時%M分')}からあります。", messages[:before_lesson][:text]
    assert_equal '明日はお休みです。', messages[:no_lesson_tomorrow][:text]
  end
end
