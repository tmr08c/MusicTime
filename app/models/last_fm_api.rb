require 'lastfm'

class LastFmApi
  PAGE_LIMIT = 200

  attr_reader :api

  def initialize
    @api = Lastfm.new('118581fa656b867fda2fa7e8737b3c18', '404a4cd5e1710cab626cf4ee57e4db38')
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
