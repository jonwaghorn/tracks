# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090930170613) do

  create_table "areas", :force => true do |t|
    t.string   "name",        :limit => 30,                               :default => "",  :null => false
    t.integer  "region_id"
    t.datetime "created_at"
    t.text     "description"
    t.decimal  "latitude",                  :precision => 9, :scale => 6, :default => 0.0
    t.decimal  "longitude",                 :precision => 9, :scale => 6, :default => 0.0
    t.integer  "zoom",                                                    :default => 0
    t.datetime "updated_at"
  end

  create_table "conditions", :force => true do |t|
    t.string "name"
  end

  create_table "faqs", :force => true do |t|
    t.string   "question",   :null => false
    t.integer  "user_id",    :null => false
    t.text     "answer",     :null => false
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feature_comments", :force => true do |t|
    t.integer  "feature_id"
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "features", :force => true do |t|
    t.string   "kind"
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "progress"
  end

  create_table "g_map_tracks", :force => true do |t|
    t.integer  "track_id"
    t.integer  "sequence"
    t.text     "points"
    t.text     "levels"
    t.integer  "zoom"
    t.integer  "num_levels"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "map_types", :force => true do |t|
    t.string "name"
    t.string "google_map_type"
  end

  create_table "medias", :force => true do |t|
    t.string   "ref_type"
    t.integer  "ref_id"
    t.string   "kind"
    t.string   "reference"
    t.integer  "user_id"
    t.string   "title"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nations", :force => true do |t|
    t.string   "name",        :limit => 30,                               :default => "",  :null => false
    t.text     "description"
    t.datetime "created_at"
    t.decimal  "latitude",                  :precision => 9, :scale => 6, :default => 0.0
    t.decimal  "longitude",                 :precision => 9, :scale => 6, :default => 0.0
    t.integer  "zoom",                                                    :default => 0
    t.datetime "updated_at"
  end

  add_index "nations", ["name"], :name => "index_nations_on_name", :unique => true

  create_table "rain_readings", :force => true do |t|
    t.integer  "region_id"
    t.decimal  "mm",        :precision => 4, :scale => 1, :default => -1.0
    t.datetime "date"
  end

  create_table "regions", :force => true do |t|
    t.string   "name",          :limit => 30,                               :default => "",  :null => false
    t.integer  "nation_id"
    t.datetime "created_at"
    t.text     "description"
    t.integer  "rain_readings",                                             :default => 0
    t.decimal  "latitude",                    :precision => 9, :scale => 6, :default => 0.0
    t.decimal  "longitude",                   :precision => 9, :scale => 6, :default => 0.0
    t.integer  "zoom",                                                      :default => 0
    t.datetime "updated_at"
    t.integer  "sequence",                                                  :default => -1
    t.text     "points"
    t.text     "levels"
    t.integer  "num_levels"
    t.integer  "zoom_factor"
    t.integer  "colour",                                                    :default => 0
  end

  create_table "settings", :force => true do |t|
    t.integer  "user_id",                    :null => false
    t.integer  "map_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "region_id",   :default => 1
  end

  create_table "specials", :force => true do |t|
    t.string "name"
    t.text   "content"
  end

  create_table "track_accesses", :force => true do |t|
    t.string "name"
    t.text   "description"
  end

  create_table "track_akas", :force => true do |t|
    t.integer "track_id"
    t.string  "name",     :limit => 40, :default => "", :null => false
  end

  create_table "track_connections", :force => true do |t|
    t.integer "track_id"
    t.integer "connect_track_id"
  end

  create_table "track_grades", :force => true do |t|
    t.string "name"
    t.text   "description"
  end

  create_table "track_reports", :force => true do |t|
    t.integer  "track_id"
    t.integer  "user_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tracks", :force => true do |t|
    t.string   "name",                  :limit => 40,                               :default => "",  :null => false
    t.integer  "area_id"
    t.string   "access_note"
    t.text     "desc_overview"
    t.text     "desc_full"
    t.text     "desc_where"
    t.text     "desc_note"
    t.decimal  "length",                              :precision => 6, :scale => 3, :default => 0.0
    t.integer  "alt_gain"
    t.integer  "alt_loss"
    t.integer  "alt_begin"
    t.integer  "alt_end"
    t.string   "alt_note"
    t.string   "grade_note"
    t.datetime "created_at"
    t.integer  "updated_by"
    t.decimal  "latitude",                            :precision => 9, :scale => 6, :default => 0.0
    t.decimal  "longitude",                           :precision => 9, :scale => 6, :default => 0.0
    t.integer  "zoom",                                                              :default => 0,   :null => false
    t.integer  "track_grade_id"
    t.integer  "track_access_id"
    t.integer  "condition_id"
    t.integer  "created_by"
    t.datetime "updated_at"
    t.string   "length_source"
    t.integer  "length_adjust_percent",                                             :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "screen_name"
    t.string   "login"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "privilege",                 :limit => 20, :default => "viewer"
    t.integer  "edits",                                   :default => 0
    t.integer  "reports",                                 :default => 0
    t.datetime "last_track_edit_at"
  end

  create_table "votes", :force => true do |t|
    t.integer  "feature_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
