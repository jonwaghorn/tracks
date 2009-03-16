class Feature < ActiveRecord::Base

  belongs_to :user
  has_many :votes
  has_many :feature_comments, :order => 'created_at ASC'

  validates_presence_of :title, :description

  KINDS = %w(feature problem)
  STATUSES = %w(open closed)
  PROGRESS = %w(new accepted developing beta implemented)

  def self.active_features
    find(:all, :conditions => ["kind = ? AND status = ?", KINDS[0], STATUSES[0]], :order => 'updated_at DESC').sort_by {|f| f.votes.length}.reverse
  end

  def self.completed_features
    find(:all, :conditions => ["kind = ? AND status = ?", KINDS[0], STATUSES[1]], :order => 'updated_at DESC')
  end

  def self.active_problems
    find(:all, :conditions => ["kind = ? AND status = ?", KINDS[1], STATUSES[0]], :order => 'updated_at DESC')
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
end
