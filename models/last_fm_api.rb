require 'lastfm'

class LastFmApi
  PAGE_LIMIT = 200

  attr_reader :api

  def initialize
    @api = Lastfm.new(ENV['last_fm_api_key'], ENV['last_fm_client_secret'])
  end

  def recent_tracks(username, count)
    [].tap do |result|
      (1..count).each_slice(PAGE_LIMIT).with_index do |slice, index|
        result.concat(api.user.get_recent_tracks(username, slice.size, index + 1 ))
      end
    end
  end

  def track_info(args)
    api.track.get_info(args)
  end
end
