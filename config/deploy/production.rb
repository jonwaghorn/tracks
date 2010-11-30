set :deploy_to, "/home/#{user}/apps/tracks"

puts "*** Deploying to \033[1;41m PRODUCTION \033[0m"

role :app, "tracks.org.nz"
role :web, "tracks.org.nz"
role :db,  "tracks.org.nz", :primary => true

set :use_sudo, false
