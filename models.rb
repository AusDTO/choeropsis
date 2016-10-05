require 'active_support/core_ext/module/delegation'

class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :batches
  has_many :notifications
end

class Batch < ActiveRecord::Base
  belongs_to :project
  has_many :snaps

  def generated?
    snaps.generated.any?
  end

  def pending?
    !generated?
  end
end

class Snap < ActiveRecord::Base
  store_accessor :bs_platform_atts, :os
  store_accessor :bs_platform_atts, :os_version
  store_accessor :bs_platform_atts, :browser
  store_accessor :bs_platform_atts, :browser_version

  scope :pending, -> { where('image_url IS NULL') }
  scope :generated, -> { where('image_url IS NOT NULL') }
  scope :with_platform_atts, -> (atts) { where('bs_platform_atts @> ?', atts.to_json) }

  belongs_to :batch

  def platform
    "#{os} #{os_version}, #{browser} (#{browser_version})"
  end
end

class Notification < ActiveRecord::Base
  belongs_to :project
end
