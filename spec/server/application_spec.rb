ENV['RACK_ENV'] = 'test'

require_relative '../../application'  # <-- your sinatra app
require 'rack/test'

describe 'API Routes' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe '/api/v1/recent_tracks' do
    context 'when a user is passed in' do
      let(:username) { 'username' }

      context 'when a track count is passed in' do
        let(:count) { 100 }
        let(:tracks) { [track] }
        let(:track) { double('track', to_h: {}) }
        let(:track_collector) { double('collector', recent_tracks: tracks) }

        before do
          allow(TrackCollector).to receive(:new).and_return(track_collector)
        end

        it 'should get the recent `count` tracks for `username`' do
          get '/api/v1/recent_tracks', { username: username, count: count }
          expect(last_response).to be_ok
          expect(TrackCollector).to have_received(:new).with(username)
          expect(track_collector).to have_received(:recent_tracks).with(count)
          expect(track).to have_received(:to_h)
        end
      end
    end
  end
end
