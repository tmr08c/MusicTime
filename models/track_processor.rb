class TrackProcessor
  attr_reader :unprocessed_tracks, :api

  TrackInfo = Struct.new(:name, :duration)

  def initialize(unprocessed_tracks, api = LastFmApi.new)
    @unprocessed_tracks = unprocessed_tracks
    @api = api
  end

  def call
    mbid_track_info + non_mbid_track_info
  end

  def non_mbid_tracks
    @non_mbid_tracks ||= unprocessed_tracks.select { |track| track['mbid'].empty? }
  end

  def mbid_tracks
    @mbid_tracks ||= unprocessed_tracks.select { |track| !track['mbid'].empty? }
  end

  def mbid_track_info
    @mbid_track_info ||= mbid_tracks.each_with_object([]) do |track, tracks|
      track_info = api.track_info(mbid: track['mbid'])
      tracks << TrackInfo.new(track_info['artist']['name'], track_info['duration'])
    end
  end

  def non_mbid_track_info
    @non_mbid_track_info ||= non_mbid_tracks.each_with_object([]) do |track, tracks|
      track_info = api.track_info(
        artist: track['artist']['content'],
        track: track['name']
      )
      tracks << TrackInfo.new(track_info['artist']['name'], track_info['duration'])
    end
  end
end
