module SharedHelper
  def tab_menus
    [
      { name: '予定変更', path: schedules_path },
      { name: 'カレンダー', path: calendars_path }
    ]
  end
end
