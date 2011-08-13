# == Schema Information
# Schema version: 20090930170613
#
# Table name: users
#
#  id                        :integer(4)      not null, primary key
#  screen_name               :string(255)
#  login                     :string(255)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  created_at                :datetime
#  updated_at                :datetime
#  remember_token            :string(255)
#  remember_token_expires_at :datetime
#  privilege                 :string(20)      default("viewer")
#  edits                     :integer(4)      default(0)
#  reports                   :integer(4)      default(0)
#  last_track_edit_at        :datetime
#

require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  has_one :setting
  has_many :votes
  has_many :features
  has_many :feature_comments
  has_many :medias

  after_create :create_default_settings

  validates_presence_of     :login, :screen_name
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..100
  validates_length_of       :screen_name, :within => 3..40
  validates_uniqueness_of   :login, :screen_name, :case_sensitive => false
  before_save :encrypt_password

  # def email
  #   login
  # end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{login}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def has_active_votes?
    votes.length > 0
  end

  def has_more_votes?
    votes.length < Vote::MAX_VOTES_PER_USER
  end

  def self.anonymize
    find(:all).each do |user|
      user.screen_name = "user_#{user.id}"
      user.login = "#{user.screen_name}@tracks.org.nz"
      user.edits = 0
      user.reports = 0
      user.save!
    end

    editor = User.new
    editor.screen_name = "Editor"
    editor.login = "editor"
    editor.password = "editor"
    editor.password_confirmation = editor.password
    editor.privilege = "viewer"
    editor.save!

    creator = User.new
    creator.screen_name = "Creator"
    creator.login = "creator"
    creator.password = "creator"
    creator.password_confirmation = creator.password
    creator.privilege = "creator"
    creator.save!

    admin = User.new
    admin.screen_name = "Admin"
    admin.login = "admin"
    admin.password = "admin"
    admin.password_confirmation = admin.password
    admin.privilege = "admin"
    admin.save!
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end

  private
    def create_default_settings
      Setting.new(:user_id => id).save!
    end
end
