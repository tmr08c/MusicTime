require 'sinatra'
require 'dotenv'
require 'json'
require 'slim'
require 'debugger'
require_relative 'models/last_fm_api'
require_relative 'models/track_collector'
require_relative 'models/track_processor'

Dotenv.load

class MusicTime < Sinatra::Base
  get '/' do
    @title = 'Music Time'
    slim :index
  end

  get '/api/v1/recent_tracks', provides: 'json' do
    if params['username'] && params['count']
      TrackRequester.new(params['username'], params['count']).tracks
    else
      'Handle Me!'
    end
  end

  private

  class TrackRequester
    attr_reader :username, :count

    def initialize(username, count)
      @username = username
      @count = Integer(count)
    end

    def tracks
      TrackCollector.new(username).recent_tracks(count).map(&:to_h).to_json
    end
  end
end
