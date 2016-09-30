require 'active_support/core_ext/hash/slice'
require 'dotenv'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'haml'
require 'friendly_id'
require './models'
require 'screenshot'

Dotenv.load

class ChoeropsisApp < Sinatra::Application
  register Sinatra::ActiveRecordExtension

  post '/projects/:project_slug/environments/:environment_slug/batch' do
    project = Project.friendly.find params[:project_slug]
    environment = project.environments.friendly.find params[:environment_slug]
    batch = environment.batches.create page: project.page
    callback_url = "http://localhost/batches/#{batch.id}/callback"
    logger.info "Going in with #{bs_settings}"
    id = generate_screenshots project, environment, callback_url
    batch.update_attribute :bs_job_id, id
    logger.info "Job ID: #{batch.bs_job_id}"
  end

  get '/batches/:batch_id/callback' do
    logger.info params
  end

  post '/batches/:batch_id/populate' do
    batch = Batch.find params[:batch_id]
    populate_screenshots batch
  end

  get '/batches/:batch_id' do
    batch = Batch.find params[:batch_id]
    haml :batch, locals: { batch: batch }
  end

  def generate_screenshots(project, environment, callback_url)
    page = project.page # Simplest case, just one page per project

    params = {
      url: page.url(environment),
      callback_url: callback_url,
      tunnel: false,
      browsers: project.platforms.collect {|platform|
        platform.attributes.with_indifferent_access.slice *platform_attributes
      }
    }

    logger.info params

    browserstack_client.generate_screenshots params
  end

  def populate_screenshots(batch)
    resp = browserstack_client.screenshots batch.bs_job_id
    batch.snaps.delete_all
    logger.info resp

    resp.each do |ss|
      platform = batch.project.platforms.find_by ss.slice *platform_attributes

      batch.snaps.create do |snap|
        snap.platform = platform
        snap.thumb_url = ss[:thumb_url]
        snap.image_url = ss[:image_url]
      end
    end
  end

  private

  def browserstack_client
    @browserstack_client ||= Screenshot::Client.new bs_settings
  end

  def platform_attributes
    [ :os,
      :os_version,
      :browser,
      :browser_version ]
  end

  def bs_settings
    { username: ENV['BROWSERSTACK_USERNAME'],
      password: ENV['BROWSERSTACK_KEY'] }
  end
end
