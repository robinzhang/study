var  _= require('underscore')._;
var backbone= require('backbone');
var express = require('express');
var app = express.createServer();
var models = require('./models/models');
var redis = require('redis');
var rc = redis.createClient(); 
rc.on('error', function (err) {
    console.log('Error ' + err);
});
app.set('view engine', 'jade');
app.set('view options', {layout: false});
app.use(express.bodyParser());
app.get('/*.(js|css)', function (req, res) {
    res.sendfile('./' + req.url);
});
app.get('/',function(req,res){
   res.render('index');
});
app.post('/api',function(req,res){
	 var name = "anytado"; 
	 var rKey = 'user:'+name; 
	 var value= [{name:'robin',sex:'男'},{name:'anytao',sex:'男'},{name:'jillzhang',sex:'女'}];
	 rc.set(rKey,JSON.stringify(value), function(err, data){
   }); 
   rc.get(rKey, function (err, data) {
        if (err) {
          res.send([]);
          return;
        }
        if (data) { 
        	var foundUser = JSON.parse(data);
          res.send(foundUser);
        } 
   });
});
app.listen(8009);