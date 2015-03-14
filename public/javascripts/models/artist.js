var app = app || {};

app.Artist = Backbone.Model.extend({
  defaults: {
    'name': '',
    'count': 0,
    'time': 0
  },
  addTrackPlay: function(track_info){
    this.set('count', this.get('count') + 1)
    this.set('time', this.get('time') + track_info['duration'] * 1)
  }
});
