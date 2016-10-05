module Snappy
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
