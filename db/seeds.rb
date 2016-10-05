JSON.parse(ENV['PROJECT_SEEDS']).each do |elem|
  project = Project.find_or_create_by! name: elem['name']
  project.update_attribute :repo, elem['repo']
  project.notifications.delete_all

  project.notifications.create! do |n|
    n.target = 'slack'
    n.webhook_url = elem['slack_url']
  end
end
