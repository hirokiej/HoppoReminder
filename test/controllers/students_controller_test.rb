require 'test_helper'

class StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = admins(:alice)
    @bob = students(:student_bob)
    @charlie = students(:student_charlie)

    ApplicationController.any_instance.stubs(:current_user).returns(@admin)
  end

  test 'should update real names in bulk' do
    get students_path

    assert_response :success

    patch bulk_update_students_path, params: {
      students: [
        { id: @bob.id, real_name: '太郎' },
        { id: @charlie.id, real_name: '次郎' }
      ]
    }
    @bob.reload
    @charlie.reload

    assert_equal '太郎', @bob.real_name
    assert_equal '次郎', @charlie.real_name
  end

  test 'should not update real name in bulk' do
    get students_path

    assert_response :success

    patch bulk_update_students_path, params: {
      students: [
        { id: @bob.id, real_name: 'ボブ' },
        { id: @charlie.id, real_name: 'チャーリー' }
      ]
    }

    assert_response :unprocessable_entity
    assert_equal '変更内容を入力してください', flash[:alert]
  end
end
