require './choeropsis_app'
require 'sucker_punch/job'
require 'slack-notifier'

class PopulateSnaps
  include SuckerPunch::Job
  include Snappy

  def perform(batch_id)
    batch = Batch.find batch_id

    browserstack_client.screenshots(batch.bs_job_id).each do |ss|
      snap = batch.snaps.with_platform_atts(ss.slice *platform_attributes).first

      snap.update_attributes thumb_url: ss[:thumb_url],
                             image_url: ss[:image_url]
    end

    logger.info "Ready! #{batch.id}"

    batch.project.notifications.each do |n|
      case n.target
      when 'slack'
        notifier = Slack::Notifier.new n.webhook_url
        url = "#{ENV['SERVER_URL_BASE']}/batches/#{batch.id}"
        message = "Snaps available (#{batch.environment}): [view them](#{url})"
        notifier.ping message
      else
        logger.warn "Unknown notifier type: #{n.target}"
      end
    end
  end
end
