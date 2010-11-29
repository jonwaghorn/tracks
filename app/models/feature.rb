# == Schema Information
# Schema version: 20090930170613
#
# Table name: features
#
#  id          :integer(4)      not null, primary key
#  kind        :string(255)
#  title       :string(255)
#  description :text
#  user_id     :integer(4)
#  status      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  progress    :string(255)
#

class Feature < ActiveRecord::Base

  belongs_to :user
  has_many :votes
  has_many :feature_comments, :order => 'created_at ASC'

  validates_presence_of :title, :description

  KINDS = %w(feature problem) # Note: the order and position is important
  STATUSES = %w(open closed) # Note: the order and position is important
  PROGRESS = %w(new accepted developing beta implemented)

  def self.active_features
    find(:all, :conditions => ["kind = ? AND status = ?", KINDS[0], STATUSES[0]], :order => 'updated_at ASC').sort_by {|f| [f.votes.length, f.updated_at]}.reverse
  end

  def self.completed_features
    find(:all, :conditions => ["kind = ? AND status = ?", KINDS[0], STATUSES[1]], :order => 'updated_at DESC')
  end

  def self.active_problems
    find(:all, :conditions => ["kind = ? AND status = ?", KINDS[1], STATUSES[0]], :order => 'updated_at ASC').sort_by {|f| [f.votes.length, f.updated_at]}.reverse
  end

  def self.completed_problems
    find(:all, :conditions => ["kind = ? AND status = ?", KINDS[1], STATUSES[1]], :order => 'updated_at DESC')
  end

  def open?
    status == STATUSES.first
  end

  def closed?
    !open?
  end
  
  def humanized_id
    id.to_s.rjust(4,'0')
  end
end
