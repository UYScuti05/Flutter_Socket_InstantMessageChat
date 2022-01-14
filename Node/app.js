const express = require('express');

const app = express();
const PORT = process.env.PORT || 4000;

const server = app.listen(PORT,()=>{
    console.log('Server is running...',PORT);
})

const io = require('socket.io')(server);

io.on('connection',(socket)=>{
    console.log("Connected successfully!",socket.id);
    socket.on('disconnect',()=>{
        console.log("Disconnected",socket.id);
    });

    socket.on('message',(data)=>{
        console.log(data);
        socket.broadcast.emit('message-receive',data);
    })
})
