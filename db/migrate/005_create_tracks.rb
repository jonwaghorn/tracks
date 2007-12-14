class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.string   :name, :limit => 40, :default => "", :null => false
      t.integer  :area_id
      t.string   :status
      t.string   :status_note
      t.text     :desc_brief
      t.text     :desc_full
      t.text     :desc_where
      t.text     :desc_note
      t.decimal  :length, :precision =>5, :scale => 2, :default => 0.0
      t.integer  :alt_gain
      t.integer  :alt_loss
      t.integer  :alt_begin
      t.integer  :alt_end
      t.string   :alt_note
      t.integer  :grade
      t.string   :grade_note
      t.datetime :date
      t.integer  :author
      t.decimal  :latitude, :precision =>9, :scale => 6, :default => 0.0
      t.decimal  :longitude, :precision =>9, :scale => 6, :default => 0.0
      t.integer  :zoom, :default => 0, :null => false
    end
  end

  def self.down
    drop_table :tracks
  end
end
