class CreateFaqs < ActiveRecord::Migration
  def self.up
    create_table :faqs do |t|
      t.string  :question, :null => false
      t.integer :user_id, :null => false
      t.text    :answer, :null => false
      t.string  :category
      
      t.timestamps
    end
  end

  def self.down
    drop_table :faqs
  end
end
