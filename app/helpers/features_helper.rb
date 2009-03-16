module FeaturesHelper
  def fmt_datetime_tbl(time)
    if time < Time.now - 1.week
      time.strftime("%d&nbsp;%b&nbsp;%y").gsub(/^0/, '')
    else
      time.strftime("%d&nbsp;%b&nbsp;%y<br/>").gsub(/^0/, '') + time.strftime("%I:%M%p").gsub(/^0/, '').downcase
    end
  end

  def fmt_datetime(time)
    time.strftime("%d %b %Y %H:%M").gsub(/^0/, '')
  end

  def progress(progress)
    title = progress.humanize
    progress_i = -1
    Feature::PROGRESS.each_with_index {|p,i| progress_i = i if p == progress}
    fill = progress_i > 0 ? 'full' : 'empty'
    progress_bar = '<img src="/images/progress_' + fill + '_l.png" alt="" title="' + title + '"/>'

    Feature::PROGRESS.each_with_index do |p,i|
      if i > 1 && i < Feature::PROGRESS.length - 1
        fill = progress_i < i ? 'empty' : 'full'
        progress_bar += '<img src="/images/progress_' + fill + '_c.png" alt="" title="' + title + '"/>'
      end
    end

    fill = Feature::PROGRESS.last == progress ? 'full' : 'empty'
    progress_bar += '<img src="/images/progress_' + fill + '_r.png" alt="" title="' + title + '"/>'
  end
end
