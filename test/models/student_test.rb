require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  setup do
    @alice = admins(:alice)
    @students = Student.all
  end

  test 'should identify from summary' do
    bob_event = { summary: schedules(:bob_first_schedule).summary }
    charlie_event = { summary: schedules(:charlie_first_schedule).summary }

    bob = Student.identify_from_summary(bob_event, @students)
    charlie = Student.identify_from_summary(charlie_event, @students)

    assert_equal 'ボブ', bob.real_name
    assert_equal 'チャーリー', charlie.real_name
  end

  test 'should not identify from summary' do
    no_match_summary = { summary: '映画を見る' }
    eve_event = { summary: 'イブと動物園' }

    no_match_result = Student.identify_from_summary(no_match_summary, @students)
    eve_result = Student.identify_from_summary(eve_event, @students)

    assert_nil no_match_result
    assert_nil eve_result
  end

  test 'should be unique for real name' do
    same_real_name = Student.new(
      admin: @alice,
      line_user_id: 'spongebobid',
      line_display_name: 'スポンジボブ',
      real_name: 'ボブ'
    )

    assert_not same_real_name.valid?
  end

  test 'should not save without real name' do
    no_real_name = Student.new(
      admin: @alice,
      line_user_id: 'nonameid',
      line_display_name: 'no name',
      real_name: ''
    )

    assert_not no_real_name.valid?
  end
end
