require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  test 'should find real name' do
    bob_event = { summary: schedules(:bob_first_schedule).summary }
    charlie_event = { summary: schedules(:charlie_first_schedule).summary }

    students = Student.all

    bob = Student.find_real_name(bob_event, students)
    charlie = Student.find_real_name(charlie_event, students)

    assert_equal 'ボブ', bob.real_name
    assert_equal 'チャーリー', charlie.real_name
  end
end
