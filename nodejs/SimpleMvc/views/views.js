var UserView = Backbone.View.extend({
   tagName:"li",
   initialize: function(options) {
        _.bindAll(this, 'render');
        this.model.bind('all', this.render);
    }, 
    render: function() {
        $(this.el).html('姓名：'+this.model.get("name") + " 性别："+ this.model.get("sex"));
        return this;
    }
});
var UsersView = Backbone.View.extend({
    initialize: function(options) { 
       this.model.users.bind('add', this.addUser); 
    }
    , addUser: function(user) {
        var view = new UserView({model: user});
        $('#user_list').append(view.render().el);
    }
});