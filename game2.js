var Level = [
'',
'xxxxxx',
'                 ',
'    xxxxxx  xxxx',
'         x     x',
'xxxxxx   xxxxx x ',
'               x',
'           xxxxx'
]

var FACE_DELAY = 8;
var BLOCK_SIZE = 100;

function random_color() {
  return '#'+Math.floor(Math.random()*16777215).toString(16);
}

function Game() {
  var Q = Quintus({ development: true })
    .include("Sprites, Scenes, 2D, Input")
    .setup({ maximize: true });


  Q.Sprite.extend("Player", {
    init: function(p) {
      this._super(p, {
        asset: Game.Assets.monster_faces[0],
        hitPoints: 10,
        damage: 5,
        x: BLOCK_SIZE,
        y: BLOCK_SIZE,
        face_count: FACE_DELAY,
        current_face: 0,
        faces: Game.Assets.monster_faces,
        angle: -5,
        points: [
            [ -50, -50 ],
            [  40, -50 ],
            [  40,  40 ],
            [ -50,  40 ]
        ]
      });
      this.update_face();
      this.add('2d, platformerControls');
    },

    step: function() {
      this.p.face_count -= 1;
      if (this.p.face_count < 0) {
        this.p.face_count = FACE_DELAY;
        this.next_face();
        this.p.angle *= -1;
      }
    },

    next_face: function() {
      this.p.current_face += 1;
      if (this.p.current_face >= this.p.faces.length) {
        this.p.current_face = 0;
      }
      this.update_face();
    },

    update_face: function() {
      this.p.asset = this.p.faces[this.p.current_face];
    }
  });

  Q.Sprite.extend("Block", {
    init: function(p) {
      this._super(p,{
        color: random_color(),
        w: BLOCK_SIZE,
        h: BLOCK_SIZE
      });
    },

    draw: function(ctx) {
      ctx.fillStyle = this.p.color;
      ctx.fillRect(-this.p.cx, -this.p.cy,
                    this.p.w,   this.p.h);
    }
  });

  Q.scene("start",function(stage) {
    var player = new Q.Player();
    stage.insert(player);

    for (var y = 0; y < Level.length; y++) {
      var row = Level[y];
      for (var x = 0; x < row.length; x++) {
        var char = row.charAt(x);
        if (char == 'x') {
          var block = new Q.Block({x: (x+0.5)*BLOCK_SIZE, y: (y+0.5)*BLOCK_SIZE});
          stage.insert(block);
        }
      }
    }


  });

  Q.load(Game.Assets.monster_faces, function() {
    Q.stageScene("start");
    Q.input.keyboardControls();
  });
}

Game.Assets = {
  monster1: 'monster1.png',
  monster2: 'monster2.png',
  monster3: 'monster3.png'
}

Game.Assets.monster_faces = [
  Game.Assets.monster1,
  Game.Assets.monster2,
];


window.addEventListener('load', Game);
