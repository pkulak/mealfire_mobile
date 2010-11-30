$.fn.quickClick = (callback) ->
  this.each ->
    el = $(this)
    
    unless window.Touch
      el.click(callback)
      return
      
    moved = false
  
    el.bind "touchstart", (e) ->
      moved = false
      el.bind 'touchmove', touchmove
      el.bind 'touchend', touchend
    
    touchmove = (e) ->
      moved = true
    
    touchend = (e) ->
      el.unbind('touchmove')
      el.unbind('touchend')
      
      unless moved
        e.preventDefault()
        callback.call(el, e)