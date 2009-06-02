class CreateMedias < ActiveRecord::Migration
  def self.up
    create_table :medias do |t|
      t.string :ref_type
      t.integer :ref_id
      t.string :kind
      t.string :reference
      t.integer :user_id
      t.string :title
      t.text :note

      t.timestamps
    end
    
    # Media.new(ref_type='track', ref_id=, kind='youtube', reference='', user_id=1).save!
    Media.new(:ref_type=>'track', :ref_id=>77, :kind=>'youtube', :reference=>'Let4lC8WPDk', :user_id=>1).save!
    Media.new(:ref_type=>'track', :ref_id=>78, :kind=>'youtube', :reference=>'5os_yZGAHGY', :user_id=>1).save!
    Media.new(:ref_type=>'track', :ref_id=>78, :kind=>'youtube', :reference=>'OlEjcrMkqtQ', :user_id=>1).save!
    Media.new(:ref_type=>'track', :ref_id=>79, :kind=>'youtube', :reference=>'5os_yZGAHGY', :user_id=>1).save!
    Media.new(:ref_type=>'track', :ref_id=>79, :kind=>'youtube', :reference=>'OlEjcrMkqtQ', :user_id=>1).save!
    
        # 
        # | id | ref_type | ref_id | kind    | reference   | user_id | title | note | created_at          | updated_at          |
        # +----+----------+--------+---------+-------------+---------+-------+------+---------------------+---------------------+
        # |  1 | track    |     77 | youtube | Let4lC8WPDk |       1 |       |      | 2009-05-18 05:29:09 | 2009-05-18 05:29:09 | 
        # |  2 | track    |     78 | youtube | 5os_yZGAHGY |       1 |       |      | 2009-05-18 05:34:04 | 2009-05-18 05:34:04 | 
        # |  3 | track    |     78 | youtube | OlEjcrMkqtQ |       1 |       |      | 2009-05-18 05:34:21 | 2009-05-18 05:34:21 | 
        # |  4 | track    |     79 | youtube | 5os_yZGAHGY |       1 |       |      | 2009-05-18 05:34:43 | 2009-05-18 05:34:43 | 
        # |  5 | track    |     79 | youtube | OlEjcrMkqtQ |       1 |       |      | 2009-05-18 05:34:51 | 2009-05-18 05:34:51 | 
        # 
    
  end

  def self.down
    drop_table :medias
  end
end
