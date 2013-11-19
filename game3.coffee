RubyMonsterGame = ->
  window.Q = Quintus(development: true).include("Sprites, Scenes, 2D, Input, UI, Touch, Anim").setup(maximize: true).controls()

  Q.Sprite.extend "Player",
    init: (p) ->
      @_super p,
        sprite: "ruby_monster"
        sheet: "sprite_map"
        animation: "basic"
        x: 105
        y: 10
        gravity: 0
        vy: -1000
        speed: 400

      @add '2d, platformerControls, animation, alwaysFaceFront'

  Q.scene "level1", (stage)->
    stage.insert new Q.Repeater
      asset: "game_background.jpg"
      speedX: 0.5
      speedY: 0.5
      type: 0
    player = new Q.Player()
    stage.insert player
    stage.add('viewport').follow(player,{ x: true, y: true })

    # tiles = new Q.TileLayer
    #   dataAsset: 'level1.tmx'
    #   sheet:     'sprite_map'

    # window.tiles = tiles

  Q.animations "ruby_monster",
    basic:
      frames: [0,1,2]
      rate: 1/2

  Q.load "game_background.jpg, sprite_map.png", ->
    Q.sheet "sprite_map", "sprite_map.png",
      tilew:100
      tileh:100

    Q.stageScene "level1"


window.addEventListener "load", RubyMonsterGame
