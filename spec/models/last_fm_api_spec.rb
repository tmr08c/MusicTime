require_relative '../../app/models/last_fm_api'
require_relative '../spec_helper'

describe LastFmApi do
  subject { LastFmApi.new }
  let(:username) { 'username' }
  let(:api) { double('api', user: user_api, track: track_api) }
  let(:user_api) { double('user', get_recent_tracks: []) }
  let(:track_api) { double('track', get_info: {}) }

  before do
    allow(subject).to receive(:api).and_return api
  end

  describe '#recent_tracks' do
    context 'when paging is not required' do
      before do
        subject.recent_tracks(username, LastFmApi::PAGE_LIMIT)
      end

      it 'should only make one request' do
        expect(user_api).to have_received(:get_recent_tracks)
          .once
          .with(username, LastFmApi::PAGE_LIMIT, 1)
      end
    end

    context 'when paging is required' do
      it 'should make multiple requests' do
        # PAGE_LIMI * 2
        expect(user_api).to receive(:get_recent_tracks)
          .exactly(1).times
          .with(username, LastFmApi::PAGE_LIMIT, 1)
        expect(user_api).to receive(:get_recent_tracks)
          .exactly(1).times
          .with(username, LastFmApi::PAGE_LIMIT, 2)
        # PAGE_LIMIT * .5
        expect(user_api).to receive(:get_recent_tracks)
          .exactly(1).times
          .with(username, LastFmApi::PAGE_LIMIT * 0.5, 3)

        subject.recent_tracks(username, LastFmApi::PAGE_LIMIT * 2.5)
      end

      context 'the response' do
        let(:tracks1) do
          [
            { name: 'foo' },
            { name: 'bar' },
          ]
        end
        let(:tracks2) do
          [
            { name: 'cat' },
            { name: 'dog' },
          ]
        end
        let(:tracks3) do
          [
            { name: 'meow' },
            { name: 'woof' },
          ]
        end

        before do
          allow(user_api).to receive(:get_recent_tracks).and_return(tracks1, tracks2, tracks3)
        end

        it 'should return a flat array with all of the responses' do
          expect(subject.recent_tracks(username, LastFmApi::PAGE_LIMIT * 2.5)).to eq(
            [
              { name: 'foo' },
              { name: 'bar' },
              { name: 'cat' },
              { name: 'dog' },
              { name: 'meow' },
              { name: 'woof' },
            ]
          )
        end
      end
    end
  end

  describe '#track_info' do
    context 'when mbid is passed in' do
      let(:args) { { mbid: mbid } }
      let(:mbid) { '123' }

      before do
        subject.track_info(args)
      end

      it 'should request the track info with the mbid'  do
        expect(track_api).to have_received(:get_info).with(args)
      end
    end

    context 'when artist and track name are passed in' do
      let(:args) { { artist: artist, name: name } }
      let(:artist) { 'formerly known as' }
      let(:name) { 'hi, my name is...' }

      before do
        subject.track_info(args)
      end

      it 'should request the track info with the track and artist name'  do
        expect(track_api).to have_received(:get_info).with(args)
      end
    end
  end
end
