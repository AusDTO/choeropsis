require './choeropsis_app'
require 'sucker_punch/job'
require 'active_support/core_ext/hash/indifferent_access'
require 'open-uri'
require 'yaml'

class SpawnBatches
  include SuckerPunch::Job
  include Snappy

  def perform(project_id, environment, gh_branch='master')
    logger.info "I was call withed #{project_id}, #{environment}, #{gh_branch}"
    project = Project.find project_id
    config_path = "https://raw.githubusercontent.com/#{
      ChoeropsisApp::GITHUB_CONTEXT}/#{project.repo}/#{gh_branch}/choeropsis.yml"

    logger.debug config_path

    conf = YAML.parse(open(config_path)).to_ruby.with_indifferent_access

    conf[:pages].each do |name, path|
      batch = Batch.create! do |b|
        b.project = project
        b.environment = environment
        b.page_name = name
        b.url = "#{conf[:environments][environment]}#{path}"
      end

      conf[:platforms].each do |platform|
        Snap.create! do |s|
          s.batch = batch
          
          platform.slice(*platform_attributes).collect do |k, v|
            s.send "#{k}=", v.to_s
          end
        end
      end

      GenerateSnaps.perform_async batch.id
    end
  end
end
