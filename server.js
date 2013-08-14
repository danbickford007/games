var WebSocketServer = require('websocket').server;
var http = require('http');

var server = http.createServer(function(request, response) {
    // process HTTP request. Since we're writing just WebSockets server
    // we don't have to implement anything.
});
server.listen(3001, function() { });

// create the server
wsServer = new WebSocketServer({
    httpServer: server
});
var clients = [];
var peer = 0;
wsServer.on('request', function(request) {
    var connection = request.accept(null, request.origin);
    connection.peer = peer;
    peer += 1;
    clients.push(connection);
    connection.on('message', function(message) {
        if (message.type === 'utf8') {
            if(message.utf8Data){
              console.log(JSON.parse(message.utf8Data));
              connection.coordinates = (JSON.parse(message.utf8Data).coor);
              var players = [];
              for(var i in clients){
                players.push(clients[i].coordinates)
              }
              var bullets = [];
              for(var i in JSON.parse(message.utf8Data).bullets){
                bullets.push(JSON.parse(message.utf8Data).bullets[i]);
              }
              connection.send(JSON.stringify({'players':players, 'bullets':bullets}));
            }
        }
    });

    connection.on('close', function(connection) {
        // close user connection
    });
});

