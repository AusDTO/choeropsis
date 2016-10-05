require 'active_support/core_ext/hash/slice'
require 'dotenv'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'haml'
require 'friendly_id'
require './models'
require 'screenshot'
require 'sucker_punch'

%w(lib jobs).each do |dir|
  Dir[File.dirname(__FILE__) + "/#{dir}/*.rb"].each {|file| require file }
end

Dotenv.load

class ChoeropsisApp < Sinatra::Application
  register Sinatra::ActiveRecordExtension

  GITHUB_CONTEXT = ENV['GITHUB_CONTEXT'] || 'AusDTO'

  # e.g.:
  # Generate production snapshots:
  #   /projects/dashboard/environments/production/batch
  # Generate local snapshots, get config from feature branch (on github):
  #   /projects/dashboard/environments/local/batch?branch=feature/foo
  post '/projects/:project_slug/environments/:environment/batch' do
    project = Project.friendly.find params[:project_slug]
    environment = params[:environment]
    gh_branch = params[:branch] || 'master'
    SpawnBatches.perform_async project.id, environment, gh_branch
  end

  get '/batches/:batch_id/callback' do
    batch = Batch.find params[:batch_id]
    PopulateSnaps.perform_async batch.id
  end

  post '/batches/:batch_id/populate' do
    PopulateSnaps.new.perform params[:batch_id]
    redirect to "/batches/#{params[:batch_id]}"
  end

  get '/batches/:batch_id' do
    batch = Batch.find params[:batch_id]
    haml :batch, locals: { batch: batch }
  end
end
