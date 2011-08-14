source 'http://rubygems.org'

# bundler requires these gems in all environments
gem "rails", "2.3.12"
gem "mysql"
gem "shorturl", "~> 0.8.4"
gem "twitter"
gem "hpricot"
gem "capistrano-ext"
#gem "will-paginate", "2.3.16"

group :stage, :production do
  gem "fcgi"
end

group :development do
  # bundler requires these gems in development
  gem "annotate", :git => "git://github.com/ctran/annotate_models.git"
  gem "rdoc"
end

group :test do
  # bundler requires these gems while running tests
  # gem "rspec"
  # gem "faker"
end
