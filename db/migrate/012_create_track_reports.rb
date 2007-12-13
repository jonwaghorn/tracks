class CreateTrackReports < ActiveRecord::Migration
  def self.up
    create_table :track_reports do |t|
      t.integer  :track_id
      t.integer  :user_id
      t.string   :status, :default => 'Green'
      t.text     :description
      t.datetime :date
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
