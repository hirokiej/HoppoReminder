require 'test_helper'

class Admin::LineInfosHelperTest < ActionView::TestCase
  def setup
    @user_with_line_info = Admin.new(
      line_channel_id: '123',
      line_channel_access_token: '123',
      line_channel_secret: '123'
    )
    @user_without_line_info = Admin.new(
      line_channel_id: nil,
      line_channel_access_token: nil,
      line_channel_secret: nil
    )
  end

  test 'return true if user has line info' do
    assert has_line_info?(@user_with_line_info)
  end

  test 'return false if user has no line info' do
    assert_not has_line_info?(@user_without_line_info)
  end
end
