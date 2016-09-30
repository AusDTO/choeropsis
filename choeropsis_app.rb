require 'sinatra/base'
require 'sinatra/activerecord'
require 'haml'

class ChoeropsisApp < Sinatra::Application
  register Sinatra::ActiveRecordExtension

  get '/' do
    'hello'
  end
end
