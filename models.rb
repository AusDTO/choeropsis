class Project < ActiveRecord::Base
  has_many :environments
  has_many :projects
  has_many :pages
end

class Environment < ActiveRecord::Base
  belongs_to :project
end

class Page < ActiveRecord::Base
  belongs_to :project
end

class Platform < ActiveRecord::Base
  belongs_to :project
end

class Batch < ActiveRecord::Base
  belongs_to :environment
end

class Snap < ActiveRecord::Base
  belongs_to :batch
  belongs_to :page
end
