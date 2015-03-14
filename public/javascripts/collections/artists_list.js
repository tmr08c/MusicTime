var app = app || {};

app.ArtistsList = Backbone.Collection.extend({
  model: app.Artist,
  orderByPlayCount: function(){
    return _.sortBy(this.toArray(), function(artist){ return artist.get('count')});
  },
  orderByPlayTime: function(){
    return _.sortBy(this.toArray(), function(artist){ return artist.get('time')});
  }
});
