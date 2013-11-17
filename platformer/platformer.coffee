random_color = ->
  "#" + Math.floor(Math.random() * 16777215).toString(16)

Platformer = ->
  window.Q = Quintus(development: true).include("Sprites, Scenes, 2D, Input, UI, Touch, Anim").setup(maximize: true).controls()

  Q.Sprite.extend "Player",
    init: (p) ->
      @_super p,
        sprite: "player" #needs to match Q.animations
        sheet: "herman"
        x: 105
        y: 10
        animation: "run"
        flip: "x"
        speed: 400
        jumpSpeed: -600
      @add '2d, platformerControls, animation, alwaysFaceFront'

    step: ->
      if @p.vx == 0
        @play "stand"
      else
        @play "run"

  Q.Sprite.extend "Gun",
    init: (p) ->
      @_super p,
        asset: "gun.png"
        flip: 'x'
        sensor: true
      @add '2d'
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
    player = new Q.Player({})
    gun = new Q.Gun({})
    stage.insert player
    stage.insert gun, player
    stage.add('viewport').follow(player,{ x: true, y: true })

    for num in [1..30]
      stage.insert new Q.Block({x: num*70+35, y: 200})

  Q.animations "player",
    run:
      frames: [4,5,6,7]
      rate: (1/4)
    stand:
      frames: [0]
      rate: 1
    withGun:
      frames: [1]
      rate: 1

  Q.load "herman.png, gun.png, bullet.png", ->
    Q.sheet "herman", "herman.png",
      tilew:140
      tileh:140
    Q.stageScene "stage1"

window.addEventListener "load", Platformer
