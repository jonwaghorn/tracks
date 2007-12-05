class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.column :name, :string, :limit => 80, :default => "", :null => false
      t.column :area_id, :integer
      t.column :status, :string
      t.column :status_note, :string
      t.column :desc_brief, :string
      t.column :desc_full, :string
      t.column :desc_where, :string
      t.column :desc_note, :string
      t.column :length, :decimal, :precision =>5, :scale => 2, :default => 0.0
      t.column :alt_gain, :integer, :default => 0
      t.column :alt_loss, :integer, :default => 0
      t.column :alt_begin, :integer, :default => 0
      t.column :alt_end, :integer, :default => 0
      t.column :alt_note, :string
      t.column :grade, :integer
      t.column :grade_note, :string
      t.column :date, :datetime
      t.column :author, :integer
      t.column :latitude, :decimal, :precision =>9, :scale => 6, :default => 0.0
      t.column :longitude, :decimal, :precision =>9, :scale => 6, :default => 0.0
      t.column :zoom, :integer, :default => 0, :null => false
    end
  end

  def self.down
    drop_table :tracks
  end
end
