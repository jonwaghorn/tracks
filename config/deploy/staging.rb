set :deploy_to, "/home/#{user}/apps/tracks.stage"

puts "*** Deploying to \033[1;41m STAGE \033[0m"

role :app, "stage.tracks.org.nz"
role :web, "stage.tracks.org.nz"
role :db,  "stage.tracks.org.nz", :primary => true

set :branch, "develop"
