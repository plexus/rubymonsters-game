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
        jumpSpeed: -800
        withGun: true
      @add '2d, platformerControls, animation, alwaysFaceFront'
      Q.input.on("action", this, "swapGun")
      Q.input.on("fire", this, "fireGun")

    step: ->
      if @p.withGun
        if @p.vx == 0
          @play "withGun"
        else
          @play "withGunRun"
      else
        if @p.vx == 0
          @play "stand"
        else
          @play "run"

    swapGun: ->
      if @p.withGun
        Q('Gun').invoke "hide"
      else
        Q('Gun').invoke "show"
      @p.withGun = !@p.withGun

    flipped: ->
      if @p.flip == 'x'
        1
      else
        -1

    fireGun: ->
      return unless @p.withGun
      bullet = new Q.Bullet
        vx: 900 * @flipped()
        x: @p.x + (115 * @flipped())
        y: @p.y + 2
        flip: @p.flip

      @p.stage.insert bullet

  Q.MovingSprite.extend "Bullet",
    init: (p) ->
      @_super p,
        asset: "bullet.png"

  Q.Sprite.extend "Gun",
    init: (p) ->
      @_super p,
        asset: "gun.png"
        flip: 'x'
        type: 0
        x: 65
        y: 10

    flipped: ->
      @p.x *= -1
      @p.flip = @container.p.flip

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
    player = new Q.Player({stage: stage})
    gun = new Q.Gun({})
    stage.insert player
    stage.insert gun, player
    player.on('flipped', gun, 'flipped')
    stage.add('viewport').follow(player,{ x: true, y: true })

    #for num in [1..30]
    stage.insert new Q.Block({x: 105, y: 500, w: 1000})

  Q.animations "player",
    run:
      frames: [4,5,6,7]
      rate: 1/4
    stand:
      frames: [0]
      rate: 1
    withGun:
      frames: [1]
      rate: 1
    withGunRun:
      frames: [1,2,3]
      rate: 1/4

  Q.load "herman.png, gun.png, bullet.png", ->
    Q.sheet "herman", "herman.png",
      tilew:140
      tileh:140
    Q.stageScene "stage1"

window.addEventListener "load", Platformer
