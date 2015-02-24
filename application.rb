require 'sinatra'
require 'json'
require_relative 'app/models/last_fm_api'
require_relative 'app/models/track_collector'
require_relative 'app/models/track_processor'
require_relative 'app/models/track_processor'

get '/api/v1/recent_tracks', provides: 'json' do
  if params['username'] && params['count']
    TrackCollector.new(params['username']).recent_tracks(Integer(params['count'])).to_json
  else
    'Handle Me!'
  end
end
