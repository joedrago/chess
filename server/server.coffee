path = require('path')
express = require('express')
{spawn} = require('child_process')

app = express()
server = require('http').Server(app)
app.use(express.static(path.join(__dirname, '..', 'client')))
io = require('socket.io')(server)

PORT = 8000
server.listen(PORT)
console.log "Listening on port #{PORT}"

io.on 'connection', (socket) ->
  socket.on 'think', (data) ->
    console.log('think', data)

    console.log "-- AILog --"

    ai = spawn(path.join(__dirname, '..', 'ai', 'ai.exe'), [data.fen])
    move = ''

    ai.stdout.on 'data', (data) ->
      move += data

    ai.stderr.on 'data', (data) ->
      console.log String(data)

    ai.on 'close', (code) ->
      move = move.replace(/[^A-Za-z0-9_]/g, '')
      console.log "-- AI Complete. Code: #{code} Sending move: #{move}"
      socket.emit('ai', { move: move })
