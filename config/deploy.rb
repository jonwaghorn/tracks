require 'capistrano/ext/multistage'
require 'bundler/capistrano'

set :application, 'tracks'
set :user, 'cheekymo'

set :stages, %w(staging production)
set :default_stage, 'staging'

set :repository, "git@github.com:jonwaghorn/tracks.git"
set :scm, :git

set :deploy_via, :copy
set :copy_cache, true
set :copy_exclude, [".git"]

set :use_sudo, false

# set :runner, user

set :chmod755, "app config db lib public vendor script script/* public/disp*"

set :group_writable, false
default_run_options[:pty] = true

set :keep_releases, 3
after "deploy:symlink", "init:copy_shared"

namespace :init do
  task :copy_shared, :roles => :app do
    run "cp -pf #{deploy_to}/to_copy/environment.rb #{current_path}/config/environment.rb"
    run "cp -pf #{deploy_to}/to_copy/database.yml #{current_path}/config/database.yml"
    run "cp -pf #{deploy_to}/to_copy/.htaccess #{current_path}/public/.htaccess"
    run "ln -s #{deploy_to}/shared/paths #{current_path}/public/paths"
  end
end

namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{latest_release}/tmp/restart.txt"
  end
end

namespace :backup do
#  before 'backup:db', 'setup_production_access'
  task :default do
    db
  end

  desc "Initiate a backup of the production database"
  task :db, :roles => :db do
    run "cd tmp; ./mybackupit.sh"
  end
end


Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'airbrake-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'airbrake/capistrano'
