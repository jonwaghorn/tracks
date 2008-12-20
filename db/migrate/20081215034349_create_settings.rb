class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.integer :user_id, :null => false
      t.integer :map_type_id
    
      t.timestamps
    end
    
    map_type = MapType.find(:first, :conditions => ['name = ?', 'Satellite'])
    User.find(:all).each do |user|
      s = Setting.new
      s.map_type_id = map_type.id
      s.user_id = user.id
      s.save!
    end
    
  end

  def self.down
    drop_table :settings
  end
end
