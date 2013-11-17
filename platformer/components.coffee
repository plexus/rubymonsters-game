Components = ->
  # Swap the direction a sprite is facing depending on where it's going
  Q.component 'alwaysFaceFront',
    added: ->
      @entity.on("step", this, "flipStep")
    flipStep: ->
      p = @entity.p
      factor = if @entity.p.backwards
        -1
      else
        1
      if p.vx * factor > 0
        p.flip = 'x'
      if p.vx * factor < 0
        p.flip = false

  Q.component 'subSprite',
    added: ->
      @entity.p.collisionMask = 0
      @entity.p.sensor = true
      @entity.on("step", this, "step")
    step: ->
      parent = @entity.p.superSprite.p
      p = @entity.p
      p.flip = parent.flip
      if p.flip == 'x'
        p.x = parent.x - p.offsetX
        p.y = parent.y + p.offsetY
      else
        p.x = parent.x + p.offsetX
        p.y = parent.y + p.offsetY



window.addEventListener "load", Components
