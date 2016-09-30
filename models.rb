class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :environments
  has_many :platforms
  has_one :page
end

class Environment < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :project
  has_many :batches
end

class Page < ActiveRecord::Base
  belongs_to :project
  has_many :snaps

  def url(environment)
    protocol = if ssl?
      "https"
    else
      "http"
    end

    "#{protocol}://#{environment.domain}#{path}"
  end
end

class Platform < ActiveRecord::Base
  belongs_to :project
  has_many :snaps
end

class Batch < ActiveRecord::Base
  belongs_to :environment
  has_many :snaps
end

class Snap < ActiveRecord::Base
  belongs_to :batch
  belongs_to :page
  belongs_to :platform
end
