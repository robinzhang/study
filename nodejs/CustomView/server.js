var express=require('express');
var app = express.createServer();
app.set('view engine','jade');
app.set('view options',{layout:false});
app.use(express.bodyParser());
app.get('/',function(req,res){
   res.render('index');
});
app.listen(8008);