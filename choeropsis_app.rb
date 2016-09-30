require 'dotenv'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'haml'
require 'friendly_id'
require './models'
require 'screenshot'
require 'active_support/core_ext/hash/slice'

Dotenv.load

class ChoeropsisApp < Sinatra::Application
  register Sinatra::ActiveRecordExtension

  post '/projects/:project_slug/environments/:environment_slug/batch' do
    project = Project.friendly.find params[:project_slug]
    environment = project.environments.friendly.find params[:environment_slug]
    batch = environment.batches.create
    callback_url = "http://localhost/batches/#{batch.id}/callback"
    logger.info "Going in with #{bs_settings}"
    id = generate_screenshots project, environment, callback_url
    batch.bs_job_id = id
    logger.info "Job ID: #{batch.bs_job_id}"
  end

  get '/batches/:batch_id/callback' do
    logger.info params
  end

  get '/' do
    'hello'
  end

  def browserstack_client
    @browserstack_client ||= Screenshot::Client.new bs_settings
  end

  def generate_screenshots(project, environment, callback_url)
    page = project.page # Simplest case, just one page per project

    params = {
      url: page.url(environment),
      callback_url: callback_url,
      tunnel: false,
      browsers: project.platforms.collect {|platform|
        platform.attributes.with_indifferent_access.slice(
          :os,
          :os_version,
          :browser,
          :browser_version)
      }
    }

    logger.info params

    browserstack_client.generate_screenshots params
  end

  private

  def bs_settings
    { username: ENV['BROWSERSTACK_USERNAME'], password: ENV['BROWSERSTACK_KEY'] }
  end
end
