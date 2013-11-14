random_color = ->
  "#" + Math.floor(Math.random() * 16777215).toString(16)

Game = ->
  window.Q = Quintus(development: true).include("Sprites, Scenes, 2D, Input, UI").setup(maximize: true)

  Q.component 'autoFlip',
    added: ->
      @entity.on("step", this, "flipStep")

    flipStep: ->
      p = @entity.p
      if (Q.inputs['left'])
        p.flip = 'x'
      if (Q.inputs['right'])
        p.flip = false


  Q.Sprite.extend "Player",
    init: (p) ->
      @_super p,
        asset: Game.Assets.monster_faces[0]
        hitPoints: 10
        damage: 5
        x: BLOCK_SIZE
        y: BLOCK_SIZE
        face_count: FACE_DELAY
        current_face: 0
        faces: Game.Assets.monster_faces
        angle: -5
        points: [[-50, -50], [40, -50], [40, 40], [-50, 40]]
        salto: 0
        score: 0
        speed_wakkel: false

      @update_face()
      @add "2d, platformerControls, autoFlip"

      window.addEventListener 'deviceorientation', (eventData) =>
        # gamma is the left-to-right tilt in degrees, where right is positive
        tilt_lr = eventData.gamma
        @p.vx = tilt_lr

    step: ->
      @p.face_count -= 1
      if @p.speed_wakkel || @p.face_count < 0 && @p.salto == 0
        @p.angle *= -1
      if @p.salto > 0
        @p.angle = @p.salto
        @p.salto -= 5
      if @p.face_count < 0
        @p.face_count = FACE_DELAY
        @next_face()

    next_face: ->
      @p.current_face += 1
      @p.current_face = 0  if @p.current_face >= @p.faces.length
      @update_face()

    update_face: ->
      @p.asset = @p.faces[@p.current_face]

    salto: ->
      @p.salto += 360 if @p.salto < 360
      @p.vy = -600

    inc_score: ->
      @p.score += 1
      Game.score_label.p.label = '' + @p.score

    collect_gem: ->
      @inc_score()
      @p.angle = -7
      @p.speed_wakkel = true
      undo_wakkel = =>
        @p.angle = 5
        @p.speed_wakkel = false
      setTimeout undo_wakkel, 1000

  Q.Sprite.extend "Ruby",
    init: (p) ->
      console.log Game.Assets.rubyred
      @_super p,
        asset: Game.Assets.rubyred
      @add "2d"
      @on "hit", this, "collision"

    collision: (coll) ->
      if coll.obj.isA 'Player'
        coll.obj.collect_gem()
        @destroy()

  Q.Sprite.extend "Block",
    init: (p) ->
      @_super p,
        color: random_color()
        w: BLOCK_SIZE
        h: BLOCK_SIZE
    #    gravity: 0
    #@add '2d'


    draw: (ctx) ->
      ctx.fillStyle = @p.color
      ctx.fillRect -@p.cx, -@p.cy, @p.w, @p.h

  Q.scene "start", (stage) ->
    player = new Q.Player({stage: stage})
    stage.insert player
    stage.add('viewport').follow(player,{ x: true, y: true })
    y = 0

    Game.score_label = stage.insert(new Q.UI.Text(
      x: Q.width - 250
      y: 100
      scale: 3
      label: '0'
    ))

    build_world = ->
      while y < Level.length
        row = Level[y]
        x = 0

        while x < row.length
          char = row.charAt(x)
          if char is "x"
            block = new Q.Block(
              x: (x + 0.5) * BLOCK_SIZE
              y: (y + 0.5) * BLOCK_SIZE
            )
            stage.insert block
          if char is "." && Math.random() < 0.2
            ruby = new Q.Ruby(
              x: (x + 0.5) * BLOCK_SIZE
              y: (y + 0.5) * BLOCK_SIZE
            )
            stage.insert ruby
          x++
        y++

    build_world()

    Q.input.on 'fire', stage, (e) ->
      player.salto()

  Q.load Game.Assets.all, ->
    Q.stageScene "start"
    Q.input.keyboardControls()

Level = [
  "......          .",
  "xxxxxx      ....x",
  ".   ......  xxxxx",
  "    xxxxxx  ",
  "...... . x.....                  ",
  "xx xxx   xxxxxxxxxxxxxxxxxxx          ",
  "..     .   ....x.......               ",
  "xx   ..x.. xxxxx.......xxxx             ",
  ".    xx.xx      xxxxxxx   xxx          ",
  "........... xxxx            xxx          ",
  "xxxxxx   xxxxxx               xxx        ",
  "x.............x                 xxx     ",
  "x    xx  xx   x                        ",
  "x      xx     x ",
  "x.............x ",
  "xxxxxxxxxxxxxxx                             ",
  ]

FACE_DELAY = 8
BLOCK_SIZE = 100

Game.Assets =
  monster1: "monster1.png"
  monster2: "monster2.png"
  monster3: "monster3.png"
  rubyred: "rubyred.png"
  rubygreen: "rubygreen.png"
  rubyblue: "rubyblue.png"

Game.Assets.monster_faces = [Game.Assets.monster1, Game.Assets.monster2]
Game.Assets.rubies        = [Game.Assets.rubyred, Game.Assets.rubygreen, Game.Assets.rubyblue]
Game.Assets.all           = Game.Assets.monster_faces.concat(Game.Assets.rubies)

window.addEventListener "load", Game
