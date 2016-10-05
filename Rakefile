# Rakefile
require 'bundler/setup'
Bundler.require(:default)

require 'sinatra/activerecord/rake'

namespace :db do
  task :load_config do
    require "./choeropsis_app"
  end
end
