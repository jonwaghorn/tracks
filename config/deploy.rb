set :application, 'tracks'
set :repository, "git@github.com:jonwaghorn/tracks.git"
set :scm, :git

set :user, 'cheekymo'

set :stages, %w(staging production)
set :default_stage, 'staging'
# set :scm_username, user
set :deploy_via, :copy
set :copy_strategy, :export

set :runner, user
#set :scm_verbose, true
# set :use_sudo, false
set :branch, "master"
# set :deploy_via, :checkout
# set :git_shallow_clone, 1

require 'capistrano/ext/multistage'
require 'bundler/capistrano'

set :chmod755, "app config db lib public vendor script script/* public/disp*"

set :group_writable, false
default_run_options[:pty] = true

after :deploy, "init:copy_shared"
# after :deploy, "init:restart"

namespace :init do
  task :copy_shared, :roles => :app do
    run "cp -pf #{deploy_to}/to_copy/environment.rb #{current_path}/config/environment.rb"
    run "cp -pf #{deploy_to}/to_copy/database.yml #{current_path}/config/database.yml"
    run "cp -pf #{deploy_to}/to_copy/.htaccess #{current_path}/public/.htaccess"
    run "ln -s #{deploy_to}/shared/paths #{current_path}/public/paths"
  end

  task :restart, :roles => :app do
    # sudo "touch #{latest_release}/tmp/restart.txt"
    run "pkill -9 -u #{user} dispatch.fcgi"
  end
end





namespace :backup do
  before 'backup:db', 'setup_production_access'
  task :default do
    db
  end

  desc "Initiate a backup of the production database"
  task :db, :roles => :db do
    run "cd tmp; ./mybackupit.sh"
  end
end
