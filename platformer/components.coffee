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
      if p.vx * factor > 0 && p.flip != 'x'
        p.flip = 'x'
        @entity.trigger('flipped')
      if p.vx * factor < 0 && p.flip
        p.flip = false
        @entity.trigger('flipped')


window.addEventListener "load", Components
