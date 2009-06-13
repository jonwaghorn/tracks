module TextHelper

  def replace_for_view(line, unlinked = false)
    # puts '### replace_for_view'
    # puts 'LINE = ' + line
    # general replacements
    line = line.gsub(/\[\[br\]\]/, '<br/>') # [[br]] => html break
    line = line.gsub(/\[\[para\]\]/, '<br/><br/>') # [[para]] => html break * 2
    line = line.gsub(/\[\[h1:(.*?)\]\]/, '</p><h2>\1</h2><h3>&nbsp;</h3><p>') # [[h1:Heading]] => heading 1
    line = line.gsub(/\[\[h2:(.*?)\]\]/, '</p><p><b>\1</b></p><p>') # [[h2:Heading]] => heading 2
    line = line.gsub(/\[\[bold:(.*?)\]\]/, '<b>\1</b>') # [[bold:text]] => bold text
    line = line.gsub(/\[\[italic:(.*?)\]\]/, '<em>\1</em>') # [[italic:text]] => italic text
    line = line.gsub(/\[\[bullet:(.*?)\]\]/, '</p><ul><li>\1</ul><p>') # [[bullet:text]] => bullet text
    line = line.gsub(/<\/ul><p>\s*<\/p><ul>/, '') # tidy adjacent bullets, kinda hacky
    line = line.gsub(/\[\[image:(http):(.*?):(.*?):(.*?):(.*?)\]\]/, '<img src="\1:\2" alt="\3" width="\4" height="\5"/>') # [[img:ref:width:height]]
    line = line.gsub(/\[\[link:tracks.org.nz(.*?)\]\]/, '[[link:http://tracks.org.nz\1]]')
    line = line.gsub(/\[\[link:www.tracks.org.nz(.*?)\]\]/, '[[link:http://tracks.org.nz\1]]')
    line = line.gsub(/\[\[link:http:\/\/www.tracks.org.nz(.*?)\]\]/, '[[link:http://tracks.org.nz\1]]')
    line = line.gsub(/\[\[link:(http:\/\/tracks.org.nz.*?) (.*?)\]\]/, '<a href="\1" title="\1" rel="nofollow">\2</a>') # [[link:ref Name]] => href
    line = line.gsub(/\[\[link:(.*?) (.*?)\]\]/, '<a href="\1" class="external" title="\1" rel="nofollow">\2</a>') # [[link:ref Name]] => href

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
          end
        rescue ActiveRecord::RecordNotFound
        end
        if name != nil
          if !unlinked
            line = line.gsub(Regexp.new('\\[\\[' + key + ':' + value.to_s + '\\]\\]'), '<a href="/' + key + '/show/' + value.to_s + '">' + name + '</a>')
          else
            line = line.gsub(Regexp.new('\\[\\[' + key + ':' + value.to_s + '\\]\\]'), name)
          end
        end
      end
    end

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

  # Change funky "smart" quotes into regular jobbies
  def fix_stupid_quotes!(s)
    s.gsub! "\342\200\230", "'"
    s.gsub! "\342\200\231", "'"
    s.gsub! "\342\200\234", '"'
    s.gsub! "\342\200\235", '"'
  end

  private

  def find_id_replacements(line)
    find_replacements(line, /\[\[(nation|region|area|track):[0-9].*?\]\]/)
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

end
