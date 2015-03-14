var app = app || {};

app.ArtistView = Backbone.View.extend({
  model: new app.Artist(),
  tagName: 'li',
  initialize: function(){
    this.template = _.template($('#artistCountTemplate').html());
  },
  render: function(){
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  }
});
