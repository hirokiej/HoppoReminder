module NavigationHelper
  def navigation_tabs
    [
      { name: '予定変更', path: schedules_path },
      { name: 'カレンダー', path: calendars_path },
      { name: '生徒一覧', path: students_path }
    ]
  end
end
