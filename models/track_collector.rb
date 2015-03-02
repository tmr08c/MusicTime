class TrackCollector
  attr_reader :username
  attr_reader :api

  def initialize(username, api = LastFmApi.new)
    @username = username
    @api = api
  end

  def recent_tracks(count)
    process(unprocessed_recent_tracks(count))
  end

  private

  def unprocessed_recent_tracks(count)
    api.recent_tracks(username, count)
  end

  def process(unprocessed_tracks)
    TrackProcessor.new(unprocessed_tracks, api).call
  end
end
