set :application, "tracks"
set :repository,  "/Users/Jonny/svnroot"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "www.tracks.org.nz"
role :web, "www.tracks.org.nz"
role :db,  "www.tracks.org.nz", :primary => true

task :restart_web_server, :roles => :web do
  # restart your web server here
end

after "deploy:start", :restart_web_server