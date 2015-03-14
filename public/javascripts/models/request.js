var app = app || {};

app.Request = Backbone.Model.extend({
  initialize: function(){
    this.requestRecentTracks(this.get('username'), this.get('count'));
    this.set('artists', new app.ArtistsList());

  },
  requestRecentTracks: function(username, count){
    self = this
    $.ajax({
      url: 'http://localhost:4567/api/v1/recent_tracks',
      dataType: 'json',
      data: {
        username: username,
        count: count
      }
    }).success(function(data){
      self.get('artists').reset();
      console.log('Received Data');
      var artist_info = {}
      _.each(data, function(track_info){
        var artist_name = track_info['name']
        if(!artist_info[artist_name]){
          artist_info[artist_name] = new app.Artist({'name': artist_name})
        }
        var artist = artist_info[artist_name];
        artist.addTrackPlay(track_info);
      })
      _.each(artist_info, function(artist){
        self.get('artists').add(artist);
      });
      console.log('Created Initial Collection');

      var playCountCollection = new app.ArtistsList(self.get('artists').orderByPlayCount());
      var playTimeCollection = new app.ArtistsList(self.get('artists').orderByPlayTime());
      console.log('Created ordered collections')

      var playCountView = new app.ArtistsView({model: playCountCollection, el: '#track-play-count-list'});
      var playTimeView = new app.ArtistsView({model: playTimeCollection, el: '#track-play-time-list'});
    });
  }
});
