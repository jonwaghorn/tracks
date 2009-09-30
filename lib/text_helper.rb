module TextHelper

  def replace_for_view(line, unlinked = false)
    # puts '### replace_for_view'
    # puts 'LINE = ' + line

    # special id => name replacements
    items = find_id_replacements(line)
    # puts 'ITEMS = ' + items.inspect
    items.each do |key, values|
      values.uniq!
      values.each do |value|
        name = nil
        begin
          case key
          when 'track'
            name = Track.find(value, :select => 'name').name
          when 'area'
            name = Area.find(value, :select => 'name').name
          when 'region'
            name = Region.find(value, :select => 'name').name
          when 'nation'
            name = Nation.find(value, :select => 'name').name
          when 'feature'
            name = Feature.find(value, :select => 'title').title
          end
        rescue ActiveRecord::RecordNotFound
        end
        if name != nil
          if !unlinked
            if (key == 'feature')
              line = line.gsub(Regexp.new('\\[\\[' + key + ':' + value.to_s + '\\]\\]'), '<a href="/features/' + value.to_i.to_s + '" title="' + name + '">' + sprintf('%04i', value.to_i) + '</a>') # this is ugly...
            else
              line = line.gsub(Regexp.new('\\[\\[' + key + ':' + value.to_s + '\\]\\]'), '<a href="/' + key + '/show/' + value.to_s + '">' + name + '</a>')
            end
          else
            line = line.gsub(Regexp.new('\\[\\[' + key + ':' + value.to_s + '\\]\\]'), name)
          end
        end
      end
    end

    # general replacements
    line = line.gsub(/\[\[br\]\]/, '<br/>') # [[br]] => html break
    line = line.gsub(/\[\[para\]\]/, '</p><p>') # [[para]] => new paragraph
    line = line.gsub(/\[\[map\]\]/, '<div id="map"></div>')
    line = line.gsub(/\[\[link:tracks.org.nz(.*?)\]\]/, '[[link:http://tracks.org.nz\1]]')
    line = line.gsub(/\[\[link:www.tracks.org.nz(.*?)\]\]/, '[[link:http://tracks.org.nz\1]]')
    line = line.gsub(/\[\[link:http:\/\/www.tracks.org.nz(.*?)\]\]/, '[[link:http://tracks.org.nz\1]]')
    line = line.gsub(/\[\[link:(http:\/\/tracks.org.nz.*?) (.*?)\]\]/, '<a href="\1" title="\1" rel="nofollow">\2</a>') # [[link:ref Name]] => href
    line = line.gsub(/\[\[link:(.*?) (.*?)\]\]/, '<a href="\1" class="external" title="\1" rel="nofollow">\2</a>') # [[link:ref Name]] => href
    line = line.gsub(/\[\[h1:(.*?)\]\]/, '</p>' + heading('\1') + '<p>') # [[h1:Heading]] => heading 1
    line = line.gsub(/\[\[h2:(.*?)\]\]/, '</p>' + heading('\1', 2) + '<p>') # [[h2:Heading]] => heading 2
    line = line.gsub(/\[\[bold:(.*?)\]\]/, '<b>\1</b>') # [[bold:text]] => bold text
    line = line.gsub(/\[\[italic:(.*?)\]\]/, '<em>\1</em>') # [[italic:text]] => italic text
    line = line.gsub(/\[\[image:(http):(.*?):(.*?):(.*?):(.*?)\]\]/, '<img src="\1:\2" alt="\3" width="\4" height="\5"/>') # [[img:ref:width:height]]
    line = line.gsub(/\[\[bullet:(.*?)\]\]/, '</p><p class="bullet">\1</p><p>') # [[bullet:text]] => bullet text
    line = line.gsub(/\[\[media:youtube:(.*?)\]\]/, youtube_player('\1'))
    line = line.gsub(/\[\[media:vorb:(.*?)\]\]/, vorb_player('\1'))
    line = line.gsub(/\[\[media:vimeo:(.*?)\]\]/, vimeo_player('\1'))

    line = generic_view_tidy(line)

    line = line.gsub('\[', '[')
    line = line.gsub('\]', ']')
  end

  def replace_for_edit(line)
    # puts '### replace_for_edit'
    # puts 'LINE = ' + line
    items = find_id_replacements(line)
    # puts 'ITEMS = ' + items.inspect
    items.each do |key, values|
      values.uniq!
      values.each do |value|
        name = nil
        begin
          case key
          when 'track'
            track = Track.find(value)
            name = track.area.region.name + ':' + (track.name.to_i == 0 ? '' : '#') + track.name
            # name = Track.find(value, :select => 'name').name
          when 'area'
            name = Area.find(value, :select => 'name').name
          when 'region'
            name = Region.find(value, :select => 'name').name
          when 'nation'
            name = Nation.find(value, :select => 'name').name
          end
        rescue ActiveRecord::RecordNotFound
        end
        if name != nil
          line = line.gsub(Regexp.new('\\[\\[' + key + ':' + value.to_s + '\\]\\]'), '[[' + key + ':' + name + ']]')
        end
      end
    end

    return line
  end

  def replace_for_update(line)
    # puts '### replace_for_update'
    # puts 'LINE = ' + line
    fix_stupid_quotes!(line)
    items = find_name_replacements(line)
    # puts 'ITEMS = ' + items.inspect
    items.each do |key, names|
      names.uniq!
      names.each do |name|
        id = nil
        begin
          case key
          when 'track'
            if name =~ /:/
              region_name, track_name = name.split(':')
              track_name = track_name[1..-1] if track_name[0,1] == '#'
              region = Region.find(:first, :conditions => ["name = ?", region_name])
              id = Track.find(:first, :conditions => ["name = ? AND area_id in (?)", track_name, region.areas.collect(&:id)], :select => 'id')
            else
              id = Track.find(:first, :conditions => ["name = ?", name], :select => 'id')
            end
          when 'area'
            id = Area.find(:first, :conditions => ["name = ?", name], :select => 'id')
          when 'region'
            id = Region.find(:first, :conditions => ["name = ?", name], :select => 'id')
          when 'nation'
            id = Nation.find(:first, :conditions => ["name = ?", name], :select => 'id')
          end
        rescue ActiveRecord::RecordNotFound
        end
        if id != nil
          line = line.gsub(Regexp.new('\\[\\[' + key + ':' + name + '\\]\\]'), '[[' + key + ':' + id.id.to_s + ']]')
        end
      end
    end

    return line
  end

  def generic_view_tidy(line)
    line.gsub(/<p>\s*<\/p>/, '') # tidy empty paras
  end

  # Change funky "smart" quotes into regular jobbies
  def fix_stupid_quotes!(s)
    s.gsub! "\342\200\230", "'"
    s.gsub! "\342\200\231", "'"
    s.gsub! "\342\200\234", '"'
    s.gsub! "\342\200\235", '"'
  end

  private

  def find_id_replacements(line)
    find_replacements(line, /\[\[(nation|region|area|track|feature):[0-9].*?\]\]/)
  end

  def find_name_replacements(line)
    find_replacements(line, /\[\[(nation|region|area|track):([a-zA-Z][a-z'#A-Z0-9 _]*?|[a-zA-Z][a-z:#'A-Z0-9 _]*?)\]\]/)
  end

  def find_replacements(line, re)
    items = { }
    i = line.index(re)
    while i != nil do
      colon = line.index(':', i)
      new_start = line.index(']]', i)
      ind = line[i+2..colon-1] # from [[ to :
      obj = line[colon+1..new_start-1]
      if items[ind] == nil
        items[ind] = [obj]
      else
        items[ind] << obj
      end
      i = line.index(re, new_start)
    end
    return items
  end

  # Tracks version of a heading
  def heading(heading, level = 1)
    level == 1 ? "</p><p class=\"spacer\"/><h2>#{heading}</h2><h3>&nbsp;</h3>" : "<p><b>#{heading}</b></p>"
  end

  def youtube_player(ref)
    width = get_video_player_width
    height = (width.to_i / 1.3333333).to_i.to_s # 4:3
    '<object width="' + width + '" height="' + height + '"><param name="movie" value="http://www.youtube.com/v/' + ref + '&hl=en&fs=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/' + ref + '&hl=en&fs=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="' + width + '" height="' + height + '"></embed></object>'
  end

  def vorb_player(ref)
    width = get_video_player_width
    height = (width.to_i / 1.3333333).to_i.to_s # 4:3
    '<embed src="http://www.vorb.org.nz/video/FlowPlayerDark.swf?config=%7Bembedded%3Atrue%2CbaseURL%3A%27http%3A%2F%2Fwww%2Evorb%2Eorg%2Enz%2Fvideo%27%2CplayList%3A%5B%7Burl%3A%27http%3A%2F%2Fwww%2Evorb%2Eorg%2Enz%2Fvideo%2Fplay%2Ejpg%27%7D%2C%7Burl%3A%27http%3A%2F%2Fwww%2Evorb%2Eorg%2Enz%2Fflvideo%2D' + ref + '%2Eflv%27%7D%2C%7Burl%3A%27http%3A%2F%2Fwww%2Evorb%2Eorg%2Enz%2Fvideo%2Fnatcoll%2D' + width + 'x' + height + '%2Eswf%27%7D%5D%2CshowPlayListButtons%3Afalse%2CshowLoopButton%3Atrue%2CinitialScale%3A%27scale%27%2Cloop%3Afalse%2CautoPlay%3Atrue%7D" width="' + width + '" height="' + height + '" scale="noscale" bgcolor="111111" type="application/x-shockwave-flash" allowFullScreen="true" allowScriptAccess="always" allowNetworking="all" pluginspage="http://www.macromedia.com/go/getflashplayer"></embed>'
  end
  
  def vimeo_player(ref)
    width = get_video_player_width
    height = (width.to_i / 1.7777777).to_i.to_s # 16:9
    '<object width="' + width + '" height="' + height + '"><param name="allowfullscreen" value="true" /><param name="allowscriptaccess" value="always" /><param name="movie" value="http://vimeo.com/moogaloop.swf?clip_id=' + ref + '&amp;server=vimeo.com&amp;show_title=0&amp;show_byline=0&amp;show_portrait=0&amp;color=&amp;fullscreen=1" /><embed src="http://vimeo.com/moogaloop.swf?clip_id=' + ref + '&amp;server=vimeo.com&amp;show_title=0&amp;show_byline=0&amp;show_portrait=0&amp;color=&amp;fullscreen=1" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="' + width + '" height="' + height + '"></embed></object>'
  end

  def get_video_player_width
    Setting::DEFAULT_VIDEO_VIEWER_WIDTH.to_s
  end
end
