(function(){
    var server = false, models;
    if (typeof exports !== 'undefined') {
        _ = require('underscore')._;
        Backbone = require('backbone');
        models = exports;
        server = true;
    } else {
        models = this.models = {};
    }
    //models
    models.UserEntry = Backbone.Model.extend({});
    models.UserCollection = Backbone.Collection.extend({
       model:models.UserEntry
    });  
    models.UsersModel=Backbone.Model.extend({
       initialize:function(){
          this.users = new models.UserCollection();
       }
    });
})()