# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TrackHelper
  include AreaHelper
  include StateHelper
  include NationHelper

  def replace_for_view(line)
#    puts '### replace_for_view'
#    puts 'LINE = ' + line
    # general replacements
    line = line.gsub(/\[\[br\]\]/, '<br/>') # [[br]] => html break
    line = line.gsub(/\[\[para\]\]/, '<br/><br/>') # [[para]] => html break * 2
    line = line.gsub(/\[\[h1:(.*?)\]\]/, '</p><h2>\1</h2><h3>&nbsp;</h3><p>') # [[h1:Heading]] => heading 1
    line = line.gsub(/\[\[h2:(.*?)\]\]/, '</p><p><b>\1</b></p><p>') # [[h2:Heading]] => heading 2
    line = line.gsub(/\[\[link:(.*?):(.*?)\]\]/, '<a href="/\2">\1</a>') # [[link:Name:local_link]] => local href

    # special id => name replacements
    items = find_id_replacements(line)
#    puts 'ITEMS = ' + items.to_s
    items.each do
      |key, values|
      values.uniq!
      values.each do
        |value|
        case key
          when 'track'
            name = get_track_name(value)
          when 'area'
            name = get_area_name(value)
          when 'state'
            name = get_state_name(value)
          when 'nation'
            name = get_nation_name(value)
          else
            name = nil
        end
        if name != nil
          line = line.gsub(Regexp.new('\\[\\[' + key + ':' + value.to_s + '\\]\\]'), '<a href="/' + key + '/show/' + value.to_s + '">' + name + '</a>')
        end
      end
    end
    
    return line
  end

  def find_id_replacements(line)
    find_replacements(line, /\[\[(nation|state|area|track):[0-9].*?\]\]/)
  end

  def replace_for_edit(line)
#    puts '### replace_for_edit'
#    puts 'LINE = ' + line
    items = find_id_replacements(line)
#    puts 'ITEMS = ' + items.to_s
    items.each do
      |key, values|
      values.uniq!
      values.each do
        |value|
        case key
          when 'track'
            name = get_track_name(value)
          when 'area'
            name = get_area_name(value)
          when 'state'
            name = get_state_name(value)
          when 'nation'
            name = get_nation_name(value)
          else
            name = nil
        end
        if name != nil
          line = line.gsub(Regexp.new('\\[\\[' + key + ':' + value.to_s + '\\]\\]'), '[[' + key + ':' + name + ']]')
        end
      end
    end

    return line
  end

  def replace_for_update(line)
#    puts '### replace_for_update'
#    puts 'LINE = ' + line
    items = find_name_replacements(line)
#    puts 'ITEMS = ' + items.to_s
    items.each do
      |key, names|
      names.uniq!
      names.each do
        |name|
        case key
          when 'track'
            id = get_track_id(name)
          when 'area'
            id = get_area_id(name)
          when 'state'
            id = get_state_id(name)
          when 'nation'
            id = get_nation_id(name)
          else
            id = nil
          end
        if id != nil
          line = line.gsub(Regexp.new('\\[\\[' + key + ':' + name + '\\]\\]'), '[[' + key + ':' + id.to_s + ']]')
        end
      end
    end

    return line
  end

  def find_name_replacements(line)
    find_replacements(line, /\[\[(nation|state|area|track):[a-zA-Z][a-zA-Z0-9 _]*?\]\]/)
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
