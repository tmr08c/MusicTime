require_relative '../../app/models/track_processor'
require_relative '../spec_helper'

describe TrackProcessor do
  subject { TrackProcessor.new(unprocessed_tracks, api) }
  let(:api) { double('api') }

  let(:unprocessed_tracks) { non_mbid_tracks + mbid_tracks }

  let(:non_mbid_tracks) { [ non_mbid_track1_info, non_mbid_track2_info ] }
  let(:mbid_tracks) { [ mbid_track1_info, mbid_track2_info ] }

  let(:mbid_track1_info) do
    {
      'mbid' => '1111',
      'artist' => { 'content' => 'band1', 'name' => 'band1' },
      'duration' => '1',
      'name' => 'title1'
    }
  end
  let(:mbid_track2_info) do
    {
      'mbid' => '2222',
      'artist' => { 'content' => 'band2', 'name' => 'band2' },
      'duration' => '2',
      'name' => 'title2'
    }
  end
  let(:non_mbid_track1_info) do
    {
      'mbid' => {},
      'artist' => { 'content' => 'band11', 'name' => 'band11' },
      'duration' => '11',
      'name' => 'title11'
    }
  end
  let(:non_mbid_track2_info) do
    {
      'mbid' => {},
      'artist' => { 'content' => 'band22', 'name' => 'band22' },
      'duration' => '22',
      'name' => 'title22'
    }
  end

  describe '#call' do
    before do
      allow(subject).to receive(:mbid_track_info).and_return [1, 2, 3]
      allow(subject).to receive(:non_mbid_track_info).and_return [7, 8, 9]
    end

    it 'should combine mbid and non-mbid track info in a flat array' do
      expect(subject.call).to eq [1, 2, 3, 7, 8, 9]
    end
  end

  describe '#non_mbid_tracks' do
    it 'should return an array of tracks that do not have a mbid' do
      expect(subject.non_mbid_tracks).to eq non_mbid_tracks
    end
  end

  describe '#mbid_tracks' do
    it 'should return an array of tracks that have a mbid' do
      expect(subject.mbid_tracks).to eq mbid_tracks
    end
  end

  describe '#mbid_track_info' do
    before do
      allow(api).to receive(:track_info)
        .with(mbid: mbid_track1_info['mbid'])
        .and_return(mbid_track1_info)
      allow(api).to receive(:track_info)
        .with(mbid: mbid_track2_info['mbid'])
        .and_return(mbid_track2_info)
    end

    it 'should request track info from the API using the mbid' do
      subject.mbid_track_info

      expect(api).to have_received(:track_info).with(mbid: mbid_track1_info['mbid'])
      expect(api).to have_received(:track_info).with(mbid: mbid_track2_info['mbid'])
    end

    it 'should return an array of TrackInfo objects' do
      expect(subject.mbid_track_info).to eq [
        TrackProcessor::TrackInfo.new(
          mbid_track1_info['artist']['content'],
          mbid_track1_info['duration']
        ),
        TrackProcessor::TrackInfo.new(
          mbid_track2_info['artist']['content'],
          mbid_track2_info['duration']
        )
      ]
    end
  end

  describe '#non_mbid_track_info' do
    before do
      allow(api).to receive(:track_info)
        .with(
          artist: non_mbid_track1_info['artist']['name'],
          track: non_mbid_track1_info['name']
        )
        .and_return(non_mbid_track1_info)

      allow(api).to receive(:track_info)
        .with(
          artist: non_mbid_track2_info['artist']['name'],
          track: non_mbid_track2_info['name']
        )
        .and_return(non_mbid_track2_info)
    end

    it 'should request track info from the API using the mbid' do
      subject.non_mbid_track_info

      expect(api).to have_received(:track_info).with(
        artist: non_mbid_track1_info['artist']['content'],
        track: non_mbid_track1_info['name']
      )
      expect(api).to have_received(:track_info).with(
        artist: non_mbid_track2_info['artist']['content'],
        track: non_mbid_track2_info['name']
      )
    end

    it 'should return an array of TrackInfo objects' do
      expect(subject.non_mbid_track_info).to eq [
        TrackProcessor::TrackInfo.new(
          non_mbid_track1_info['artist']['name'],
          non_mbid_track1_info['duration']
        ),
        TrackProcessor::TrackInfo.new(
          non_mbid_track2_info['artist']['name'],
          non_mbid_track2_info['duration']
        )
      ]
    end
  end
end
