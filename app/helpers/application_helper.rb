module ApplicationHelper
  def format_japanese_datetime(datetime)
    datetime.strftime('%-m月%-d日%H時%M分')
  end
end
