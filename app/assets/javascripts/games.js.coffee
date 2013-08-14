# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

$(document).ready ->
  CANVAS_WIDTH = 1000
  CANVAS_HEIGHT = 600
  window.img = new Image()
  img.src = 'assets/jet.png'
  window.player_left = 500
  window.player_top = 500
  window.players = []
  window.bullets = []
  window.my_bullets = []
  window.enemies = []
  window.playerNum = 0
  window.canvasElement = $("<canvas id='the_canvas' width='" + CANVAS_WIDTH + "' height='" + CANVAS_HEIGHT + "'></canvas>")
  window.canvas = canvasElement.get(0).getContext("2d")
  canvasElement.appendTo('body')
  setKeys()



  window.WebSocket = window.WebSocket || window.MozWebSocket

  window.connection = new WebSocket('ws://192.168.0.12:3001')

  connection.onopen = () ->
    $("#war").append('...connected...')
  
  connection.onmessage = (message) ->
    players = JSON.parse(message.data).players
    bs = JSON.parse(message.data).bullets
    for i in players
      if i
        enemies.push i
        canvas.drawImage(img, i.left, i.top)
    for i in bs
      if i
        bullets.push i




  FPS = 30
  setInterval () -> 
    run()
  , 1000 / FPS

run = () ->
  clear()
  draw()
  drawEnemies()
  moveBullets()
  connection.send(JSON.stringify({'coor':{'top':player_top, 'left':player_left}, 'bullets':my_bullets}))


clear = () ->
  canvas.clearRect(0, 0, 1000, 600)

draw = () ->
  canvas.drawImage(img, player_left, player_top)

setKeys = () ->
  $(document).on 'keydown', (e) ->
    if e.keyCode == 37 || e.keyCode == 97
      player_left -= 5
    if e.keyCode == 39 || e.keyCode == 100
      player_left += 5
    if e.keyCode == 40 || e.keyCode == 115
      player_top += 5
    if e.keyCode == 38 || e.keyCode == 119
      player_top -= 5
    if e.keyCode == 32 || e.charCode == 32
      my_bullets.push({'top':player_top, 'left':(player_left + 50)})
    if e.keyCode == 13
      connection.send(JSON.stringify({'coor':{'top':player_top, 'left':player_left}}))
      playerNum += 1

moveBullets = () ->
  for i in bullets.length by 1
    top = bullets[i]['top'] - 5
    bullets[i]['top'] = top
    canvas.fillStyle = "#000"
    console.log(">>>>>>"+bullets[i]['left']+"::"+top)
    canvas.fillText("X", bullets[i]['left'], top)

drawEnemies = () ->
  for enemy in enemies
    if enemy
      canvas.drawImage(img, enemy.left, enemy.top)

class Player
  constructor: (@name, @top, @left) ->
    console.log 'new player'
    canvas.drawImage(img, @left, @top)
  top: ->
    @top
  left: ->
    @left
  setPosition: (top, left) ->
    @top = top
    @left = left 
