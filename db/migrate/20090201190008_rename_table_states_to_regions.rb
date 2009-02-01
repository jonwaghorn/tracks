class RenameTableStatesToRegions < ActiveRecord::Migration
  def self.up
    rename_column :state_rain_readings, :state_id, :region_id
    rename_table :state_rain_readings, :rain_readings
    rename_table :states, :regions
    rename_column :settings, :state_id, :region_id
    rename_column :areas, :state_id, :region_id

    do_the_replace_thing('[state:', '[region:')
  end

  def self.down
    do_the_replace_thing('[region:', '[state:')

    rename_column :areas, :region_id, :state_id
    rename_column :settings, :region_id, :state_id
    rename_table :regions, :states
    rename_table :rain_readings, :state_rain_readings
    rename_column :state_rain_readings, :region_id, :state_id
  end
  
  def self.do_the_replace_thing(search, replace)
    Track.find(:all).each do |t|
      t.access_note = t.access_note.gsub(search, replace)
      t.desc_overview = t.desc_overview.gsub(search, replace)
      t.desc_full = t.desc_full.gsub(search, replace)
      t.desc_note = t.desc_note.gsub(search, replace)
      t.alt_note = t.alt_note.gsub(search, replace)
      t.grade_note = t.grade_note.gsub(search, replace)
      t.desc_overview = ' ' if t.desc_overview.empty? || t.desc_overview == '.'
      t.save!
    end

    Area.find(:all).each do |a|
      a.description = a.description.gsub(search, replace)
      a.save!
    end

    Region.find(:all).each do |s|
      s.description = s.description.gsub(search, replace)
      s.save!
    end

    Nation.find(:all).each do |n|
      n.description = n.description.gsub(search, replace)
      n.save!
    end

    Faq.find(:all).each do |f|
      f.answer = f.answer.gsub(search, replace)
      f.save!
    end

    Special.find(:all).each do |s|
      s.content = s.content.gsub(search, replace)
      s.save!
    end

    TrackReport.find(:all).each do |tr|
      tr.description = tr.description.gsub(search, replace)
      tr.save!
    end
  end
end
