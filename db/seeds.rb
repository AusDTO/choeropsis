dashboard = Project.create! name: 'dashboard'

production = dashboard.environments.create! name: 'production', domain: 'dashboard.gov.au'

page = dashboard.create_page path: '/'

dashboard.platforms.create! do |p|
  p.os = 'Windows'
  p.os_version = '7'
  p.browser = 'ie'
  p.browser_version = '10.0'
end

dashboard.platforms.create! do |p|
  p.os = 'Windows'
  p.os_version = '10'
  p.browser = 'ie'
  p.browser_version = '11.0'
end
