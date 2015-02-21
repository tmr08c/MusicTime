require_relative '../../app/models/track_collector'
require_relative '../spec_helper'

describe TrackCollector do
  subject { TrackCollector.new(username, api) }
  let(:username) { 'username' }
  let(:count) { 500 }
  let(:api) { double('LastFmApi', recent_tracks: []) }
  let(:unprocessed_tracks) { [] }

  describe '#recent_tracks' do

    before do
      allow(subject).to receive(:unprocessed_recent_tracks).and_return(unprocessed_tracks)
      allow(subject).to receive(:process)
    end

    it 'should collect and process the tracks' do
      subject.recent_tracks(count)

      expect(subject).to have_received(:unprocessed_recent_tracks).with(count)
      expect(subject).to have_received(:process).with(unprocessed_tracks)
    end
  end

  describe '#unprocessed_recent_tracks' do
    before do
      allow(subject).to receive(:api).and_return(api)
    end

    it 'should request the recent tracks from its api' do
      subject.send(:unprocessed_recent_tracks, count)

      expect(subject.api).to have_received(:recent_tracks).with(username, count)
    end
  end

  describe '#process' do
    let(:track_processor) { double('processor', call: true) }

    before do
      allow(TrackProcessor).to receive(:new).and_return(track_processor)
    end

    it 'should create a new TrackProcessor' do
      subject.send(:process, unprocessed_tracks)

      expect(TrackProcessor).to have_received(:new).with(unprocessed_tracks, subject.api)
      expect(track_processor).to have_received(:call)
    end
  end
end
