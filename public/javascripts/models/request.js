var app = app || {};

app.Request = Backbone.Model.extend({
  initialize: function(){
    this.set('artists', new app.ArtistsList());
    this.requestRecentTracks(this.get('username'), this.get('count'));
  },
  requestRecentTracks: function(username, count){
    console.log("Requesting Tracks")
    self = this
    $.ajax({
      url: 'http://localhost:4567/api/v1/recent_tracks',
      dataType: 'json',
      timeout: 5 * 10000 * 60,
      data: {
        username: username,
        count: count
      }
    }).success(function(data){
      self.get('artists').reset();
      console.log('Received Data');
      $('#loading-message').html('Successfully Retrieved Tracks!<br>Grouping Them by Artist');
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

      $('#banner').replaceWith(
        "<div id='results-container' class='container'>" +
          "<div class='row'>" +
            "<div class='col-md-6'>" +
              "<h1>Artist by Play Time</h1>" +
              "<ul id='track-play-time-list' class='track-list'></ul>" +
            "</div>" +
            "<div class='col-md-6'>" +
              "<h1>Artist by Play Count</h1>" +
              "<ul id='track-play-count-list' class='track-list'></ul>" +

            "</div>" +
          "</div>" +
        "</div>"
      );
      var playCountView = new app.ArtistsView({model: playCountCollection, el: '#track-play-count-list'});
      var playTimeView = new app.ArtistsView({model: playTimeCollection, el: '#track-play-time-list'});
    }).error(function(data){
      $('#loading-message').html("Oh no! We got an error<br>Please <a href=''>try again</a>!")
    });
  }
});
