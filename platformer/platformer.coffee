random_color = ->
  "#" + Math.floor(Math.random() * 16777215).toString(16)

Platformer = ->
  window.Q = Quintus(development: true).include("Sprites, Scenes, 2D, Input, UI, Touch, Anim").setup(maximize: true).controls()

  console.log "Platformer"

  Q.Sprite.extend "Player",
    init: (p) ->
      console.log "init herman"
      @_super p,
        sprite: "player" #needs to match Q.animations
        sheet: "herman"
        x: 105
        y: 105
        animation: "run"
        flip: "x"
        speed: 400
        jumpSpeed: -600
      @add '2d, platformerControls, animation'

    step: ->
      if @p.vx == 0
        @play "stand"
      else
        @play "run"
      if @p.vx > 0
        @p.flip = 'x'
      if @p.vx < 0
        @p.flip = false


  Q.Sprite.extend "Block",
    init: (p) ->
      @_super p,
        color: random_color()
        w: 70
        h: 70

    draw: (ctx) ->
      ctx.fillStyle = @p.color
      ctx.fillRect -@p.cx, -@p.cy, @p.w, @p.h

  Q.scene "stage1", (stage) ->
    console.log "stage1!"
    player = new Q.Player({stage: stage})
    stage.insert player
    stage.add('viewport').follow(player,{ x: true, y: true })

    for num in [1..10]
      stage.insert new Q.Block({x: num*70+35, y: 200})

  Q.animations "player",
    run:
      frames: [1,2]
      rate: (1/4)
    stand:
      frames: [0,0,0,4]
      rate: 1

  Q.load "herman.png", ->
    Q.sheet "herman", "herman.png",
      tilew:140
      tileh:140
    Q.stageScene "stage1"

window.addEventListener "load", Platformer
