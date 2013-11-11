window.addEventListener('load', function(e) {

    var Q = Quintus({
        development: true
    }).include("Sprites, Scenes, 2D, Input")
      .setup({
          maximize: true
      });

});
