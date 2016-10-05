require './choeropsis_app'
require 'sucker_punch/job'

class GenerateSnaps
  include SuckerPunch::Job
  include Snappy

  def perform(batch_id)
    batch = Batch.find batch_id

    params = {
      url: batch.url,
      callback_url: "#{ENV['SERVER_URL_BASE']}/#{batch.id}/callback",
      tunnel: false,
      browsers: batch.snaps.collect {|snap| snap.bs_platform_atts.collect {|k, v| [k, v.to_s]}.to_h }
    }

    logger.info params
    id = browserstack_client.generate_screenshots params
    batch.update_attribute :bs_job_id, id
    logger.info "Job ID: #{batch.bs_job_id}"
  end
end
