var UserController={
   init: function(options) { 
   	    var view;
        this.model = new models.UsersModel(); 
        view=this.view = new UsersView({model:this.model});
        _.each(options,function(o){ 
        	  view.model.users.add(o);
        }); 
    }
};