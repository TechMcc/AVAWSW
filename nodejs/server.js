var server=require('http').createServer(handler),
    socketio=require('socket.io').listen(server),
    fs=require('fs');

server.listen(8080);
function handler(request,respons){
  fs.readFile(__dirname+'/index.html',function(errors,filedata){
    if(errors){
      respons.writeHead(500);
      return response.end('Server Error!(T_T)');
    }
    respons.writeHead(200);
    respons.write(filedata);
    respons.end();
  });
}

socketio.sockets.on('connection',function(socket){
  socket.on('recogresult',function(receivedata){
    console.log(receivedata);
    receivedata='';
  });
});
