require_relative './config/environment'
require 'sinatra/activerecord/rake'
task :environment do
  require_relative './config/environment'
end
task :console => :environment do
  Pry.start
end
