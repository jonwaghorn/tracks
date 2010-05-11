namespace :tracks do

  desc "Anonymize the database"
  task :anonymize => :environment do
    User.anonymize
  end
end
