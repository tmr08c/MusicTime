require 'sinatra'
require 'json'
require 'slim'
require 'debugger'
require_relative 'models/last_fm_api'
require_relative 'models/track_collector'
require_relative 'models/track_processor'
require_relative 'models/track_processor'


get '/' do
  @title = 'Music Time'
  slim :index
end

get '/api/v1/recent_tracks', provides: 'json' do
  if params['username'] && params['count']
    TrackCollector.new(params['username']).recent_tracks(Integer(params['count'])).map(&:to_h).to_json
  else
    'Handle Me!'
  end
end
