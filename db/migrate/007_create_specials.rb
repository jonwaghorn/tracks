class CreateSpecials < ActiveRecord::Migration
  def self.up
    create_table :specials do |t|
      t.string :name
      t.text   :content
    end
    
    Special.create :name => 'Index', :content => 'home fixme'
    Special.create :name => 'About', :content => 'about fixme'
    Special.create :name => 'Contact', :content => 'contact fixme'
    Special.create :name => 'FAQ', :content => 'faq fixme'
    Special.create :name => 'Policy', :content => 'policy fixme'
  end

  def self.down
    drop_table :specials
  end
end
