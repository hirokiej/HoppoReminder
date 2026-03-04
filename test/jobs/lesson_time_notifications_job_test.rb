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
end
