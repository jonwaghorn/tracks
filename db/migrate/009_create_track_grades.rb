class CreateTrackGrades < ActiveRecord::Migration
  def self.up
    create_table :track_grades do |t|
      t.string :name
      t.text   :description
    end
    
    TrackGrade.create :name => 'Beginner', :description => 'Fairly flat, wide and smooth track or gravel road. Suitable for all first-time riders.'
    TrackGrade.create :name => 'Easy', :description => 'Gentle climbs and easily avoidable obstacles such as rocks and potholes. You couldn\'t ride it in your sleep, but most beginners will still enjoy these rides.'
    TrackGrade.create :name => 'Intermediate', :description => 'Challenging riding with steep slopes and/or tricky obstacles, possibly on a narrow track with poor traction. Requires riding experience and some fitness.'
    TrackGrade.create :name => 'Advanced', :description => 'A mixture of long steep climbs, loose track surfaces, difficult and/or dangerous obstacles to avoid or jump over. Some sections will be easier to walk.'
    TrackGrade.create :name => 'Expert', :description => 'Killer climbs, dangerous drop-offs, sharp corners, numerous tricky obstacles. Some sections are definitely safer and easier to walk.'
    TrackGrade.create :name => 'Extreme', :description => 'Trials skills essential to clear many huge obstacles. High risk level. Only a handful of riders will enjoy these rides, apart from bike\'n\'hike enthusiasts.'

    remove_column :tracks, :grade
    add_column :tracks, :track_grade_id, :integer
  end

  def self.down
    drop_table :track_grades

    remove_column :tracks, :track_grade_id
    add_column :tracks, :grade, :string
  end
end
