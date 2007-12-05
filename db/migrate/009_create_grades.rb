class CreateGrades < ActiveRecord::Migration
  def self.up
    create_table :grades do |t|
      t.column :name, :string
      t.column :description, :string
    end
    
    Grade.create :name => 'Beginner', :description => 'Fairly flat, wide and smooth track or gravel road. Suitable for all first-time riders.'
    Grade.create :name => 'Easy', :description => 'Gentle climbs and easily avoidable obstacles such as rocks and potholes. You couldn\'t ride it in your sleep, but most beginners will still enjoy these rides.'
    Grade.create :name => 'Intermediate', :description => 'Challenging riding with steep slopes and/or tricky obstacles, possibly on a narrow track with poor traction. Requires riding experience and some fitness.'
    Grade.create :name => 'Advanced', :description => 'A mixture of long steep climbs, loose track surfaces, difficult and/or dangerous obstacles to avoid or jump over. Some sections will be easier to walk.'
    Grade.create :name => 'Expert', :description => 'Killer climbs, dangerous drop-offs, sharp corners, numerous tricky obstacles. Some sections are definitely safer and easier to walk.'
    Grade.create :name => 'Extreme', :description => 'Trials skills essential to clear many huge obstacles. High risk level. Only a handful of riders will enjoy these rides, apart from bike\'n\'hike enthusiasts.'

    remove_column :tracks, :grade
    add_column :tracks, :grade_id, :integer
  end

  def self.down
    drop_table :grades

    remove_column :tracks, :grade_id
    add_column :tracks, :grade, :string
  end
end
