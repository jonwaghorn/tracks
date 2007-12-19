class AddConditions < ActiveRecord::Migration
  def self.up
    create_table :conditions do |t|
      t.string :name
    end
    
    Condition.create :name => 'Single track'
    Condition.create :name => 'Double track'
    Condition.create :name => '4wd'
    Condition.create :name => 'Gravel road'
    Condition.create :name => 'Sealed road'
    Condition.create :name => 'Open'

    add_column :tracks, :condition_id, :integer
  end

  def self.down
    drop_table :conditions

    remove_column :tracks, :condition_id
  end
end
