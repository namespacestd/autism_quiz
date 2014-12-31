// Setup basic express server

var express = require("express");
var app = express();
var server = require('http').createServer(app);
var io = require('socket.io')(server);
var port = process.env.PORT || 3001;
var http = require('http');
var mysql = require('mysql');

var sqlInfo = {
   host: '54.183.61.83',
   user: 'root',
   password: 'mysql77!',
   database: 'anime'
}
client = mysql.createConnection(sqlInfo);
client.connect();

client.query('SELECT * from scores', function(err, rows, fields) {
  if (err) throw err;

  console.log(rows);
});

server.listen(port, function () {
  console.log('Server listening at port %d', port);
});

app.use(express.static(__dirname + '/public'));

var current_users = [];

io.on('connection', function (socket) {
  var socket_username = "Unknown";

  socket.emit('username_request', function(data) {
  });
  socket.on("join_chat", function(data) {
    socket.emit("username_request", "request");
  });
  socket.on('username_response', function(data) {
    socket_username = data;
    current_users.push(data);
    console.log(current_users);
    socket.emit("current_users", current_users);
  });
  socket.on("send_message", function(data) {
    console.log("MESSAGE " + data);
    socket.emit("message_sent", socket_username + ": " + data);
    socket.broadcast.emit("message_sent", socket_username + ": " + data);
  });
  socket.on('score_update', function(data) {
    client.query('SELECT * from scores', function(err, rows, fields) {
      if (err) throw err;

      var score_map = {};

      for(var i=0; i<rows.length; i++) {
        var score = (rows[i]["correct"] * 2) - rows[i]["wrong"];
        if(score < 0) {
          score = 0;
        }
        score_map[rows[i]["username"]] = {
          "score" : score,
          "correct" : rows[i]["correct"],
          "wrong" : rows[i]["wrong"],
          "total" : rows[i]["correct"] + rows[i]["wrong"]
        };
      }
      socket.emit('score_update', { 
        scores: score_map
      });
    });
  });
});
