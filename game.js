function slow_down(sprite) {
    if (sprite.p.vx > 0) {
        sprite.p.vx -= 10;
        if (sprite.p.vx < 0) sprite.p.vx = 0;
    }
    if (sprite.p.vx < 0) {
        sprite.p.vx += 10;
        if (sprite.p.vx > 0) sprite.p.vx = 0;
    }
}

window.addEventListener('load',function(e) {


    // Set up a standard Quintus instance with only the
    // Sprites and Scene module (for the stage support) loaded.
    var Q = window.Q = Quintus().include("Sprites, Scenes, 2D, Input")
        .setup({ width: 2000, height: 1000 });

    // Draw vertical lines at every 100 pixels for visual indicators
    // function drawLines(ctx) {
    //     ctx.save();
    //     ctx.strokeStyle = '#FFFFFF';
    //     for(var x = 0;x < 1000;x+=100) {
    //         ctx.beginPath();
    //         ctx.moveTo(x,0);
    //         ctx.lineTo(x,600);
    //         ctx.stroke();
    //     }
    //     ctx.restore();
    // }

    // Create a simple scene that adds two shapes on the page
    Q.scene("start",function(stage) {

        // A basic sprite shape a asset as the image
        var sprite1 = new Q.Sprite({ x: 325, y: 400, asset: 'monster1.png',
                                     angle: 0, collisionMask: 0, scale: 1});
        sprite1.p.points = [
            [ -50, -50 ],
            [  40, -50 ],
            [  40,  40 ],
            [ -50,  40 ]
        ];
        stage.insert(sprite1);
        // Add the 2D component for collision detection and gravity.
        sprite1.add('2d')

        sprite1.on('step',function() {

        });

        // A red platform for the other sprite to land on
        var sprite2 = new Q.Sprite({ x: 325, y: 800, w: 2000, h: 100 });
        sprite2.draw= function(ctx) {
            ctx.fillStyle = '#FF0000';
            ctx.fillRect(-this.p.cx,-this.p.cy,this.p.w,this.p.h);
        };
        stage.insert(sprite2);

        // A red platform for the other sprite to land on
        var sprite3 = new Q.Sprite({ x: 1200, y: 400, w: 100, h: 1000 });
        sprite3.draw= function(ctx) {
            ctx.fillStyle = '#0000FF';
            ctx.fillRect(-this.p.cx,-this.p.cy,this.p.w,this.p.h);
        };
        stage.insert(sprite3);
        sprite3.p.vx = -1000;

        sprite3.on('hit', function(e) {
            sprite1.p.vx = -1000;
            sprite3.p.x += 50;
            sprite3.p.w -= 5;
        });

        // Bind the basic inputs to different behaviors of sprite1
        Q.input.on('up',stage,function(e) {
            sprite1.p.vy = - 300;
        });

        // Q.input.on('down',stage,function(e) {
        //     sprite1.p.scale += 0.1;
        // });

        Q.input.on('left',stage,function(e) {
            sprite1.p.vx -= 100;
        });

        Q.input.on('right',stage,function(e) {
            sprite1.p.vx += 100;
        });

        Q.input.on('fire',stage,function(e) {
            sprite1.p.vy = - 500;
        });

        Q.input.on('action',stage,function(e) {
            sprite1.p.x = 500;
            sprite1.p.y = 100;
        });

        sprite1.on('step', function(e) {
            slow_down(sprite1);
            slow_down(sprite3);
        });
        // Draw some lines after each frame
        //stage.on('postrender',drawLines);
    });

    Q.load('monster1.png',function() {

        // Start the show
        Q.stageScene("start");

        // Turn visual debugging on to see the
        // bounding boxes and collision shapes
        //Q.debug = true;

        // Turn on default keyboard controls
        Q.input.keyboardControls();
    });

});
