class CreateTrackReports < ActiveRecord::Migration
  def self.up
    create_table :track_reports do |t|
      t.column :track_id, :integer
      t.column :user_id, :integer
      t.column :status, :string, :default => 'Green'
      t.column :description, :string
      t.column :date, :datetime
    end
    
    # status settings
    #   green  - ok
    #   orange - be aware
    #   red    - warning, danger/closure
  end

  def self.down
    drop_table :track_reports
  end
end
