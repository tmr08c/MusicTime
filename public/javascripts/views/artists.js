var app = app || {};

app.ArtistsView = Backbone.View.extend({
  initialize: function(){
    this.render();
  },
  render: function(){
    var self = this;
    self.$el.html('')
    _.each(this.model.toArray(), function(artist, i){
      self.$el.prepend((new app.ArtistView({model: artist})).render().$el);
    });
    self.$el.append('<hr>');
    return this;
  }
});
