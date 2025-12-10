module ApplicationHelper
  def default_meta_tags
    {
      site: 'ほっぽリマインダー',
      reverse: true,
      charset: 'utf-8',
      description: '',
      keywords: 'ほっぽリマインダー, hopporeminder, ほっぽり, リマインダー, reminder, レッスン, LINE公式, Googleカレンダー',
      og: {
        title: :title,
        type: 'website',
        site_name: 'ほっぽリマインダー',
        description: :description,
        image: image_url('ogp.png'),
        url: 'https://hopporeminder.fly.dev',
        local: 'ja-JP'
      },
      twitter: {
        card: 'summary_large_image',
        site: '@hirokiej'
      }
    }
  end

  def format_japanese_datetime(datetime)
    I18n.l(datetime, format: :with_weekday)
  end
end
