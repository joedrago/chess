log = (text) ->
  $('#output').append("* " + text + "<br>");
  o = document.getElementById("output");
  o.scrollTop = o.scrollHeight;

class ChessGame
  constructor: ->
    @game = new Chess()
    @board = ChessBoard('board', {
      draggable: true
      onDragStart: @onDragStart.bind(this)
      onDrop: @onDrop.bind(this)
      onSnapEnd: @onSnapEnd.bind(this)
    })
    @socket = io()
    @socket.on 'ai', @onAI.bind(this)

    @newGame()

  update: ->
    @board.position(@game.fen()) # Updates UI board with game contents

  onSnapEnd: ->
    @update()
    # console.log "onSnapEnd", @board.fen()

  onDragStart: (source, piece, position, orientation) ->
    if @game.game_over()
      return false

    # Only allow the player to move their own pieces
    if (orientation == 'white' && piece.search(/^w/) == -1) || (orientation == 'black' && piece.search(/^b/) == -1)
      return false

  onDrop: (source, target) ->
    # see if the move is legal
    move = @game.move {
      from: source,
      to: target,
      promotion: 'q' # NOTE: always promote to a queen for example simplicity
    }

    # illegal move
    if move == null
      log("Illegal move, ignoring")
      return 'snapback'

    log("Move! new board position: #{@game.fen()}")
    if @game.game_over()
      log("Game over!")
    else
      @think()

  think: ->
    log("AI: Thinking...")
    @socket.emit('think', { fen: @game.fen() })

  onAI: (data) ->
    console.log("AI Response: ", data)
    log("AI: Move: #{data.move}")
    result = @game.move(data.move, {sloppy: true})
    console.log 'Move Result: ', result
    if result == null
      log("AI made an illegal move! Write better code!")
    else
      @update()

  newGame: ->
    @board.start()

$(document).ready ->
  game = new ChessGame
