module NavigationHelper
  def navigation_tabs
    [
      { name: 'レッスン変更', path: schedules_path },
      { name: '生徒一覧', path: students_path }
    ]
  end
end
