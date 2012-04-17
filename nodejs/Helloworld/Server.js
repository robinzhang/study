var express  = require('express')
    ,app = express.createServer();
app.use(express.bodyParser());
app.get('/',function(req,res){
   res.send('Hello World!');
});
app.listen(8003);