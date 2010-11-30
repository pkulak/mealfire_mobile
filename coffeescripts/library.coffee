window.callAPI = (path, options) ->
  if window.token
    options.data = $.extend options.data || {}, token: window.token

  $.ajax
    url: "http://mealfire.com/api/v2/#{path}.jsonp?callback=?"
    dataType: 'jsonp'
    data: options.data
    success: (data) ->
      if !data[0]
        alert data[1]
        options.error(data[1]) if options.error
      else
        options.success(data[1]) if options.success

window.Header = {}

window.Header.loading = ->
  $('#app-header').html $('<h1></h1>').text('Loading...')
  
window.Header.setTitle = (title, back) ->
  $('#app-header').html $('<h1></h1>').text(title)
  
  if back
    Header.addButton
      text: 'Back'
      className: 'back-button'
      click: -> window.location = back if back

window.Header.addButton = (button) ->
  b = $('<a href="#"></a>').addClass(button.className || 'button')
  b.html(button.text)
  $('#app-header').prepend(b)
  
  b.quickClick (e) ->
    e.stopPropagation()
    e.preventDefault()
    button.click()

window.Header.addDropdown = (buttons) ->
  Header.addButton className: 'more-button', click: ->
    dropdown = $('<ul class="dropdown"></ul>')
      
    $(document).quickClick -> dropdown.remove()
          
    $.each buttons, (i, button) ->
      li = $('<li></li>')
      li.html(button.text)
      
      li.quickClick (e) ->
        dropdown.remove()
        button.click()
        e.stopPropagation()
        
        # Get rid of the quickClick binding
        $(document).unbind 'touchstart'
              
      dropdown.append(li)
      
    $('#app-header').append(dropdown)

window.Header.swapButtons = (newButton) ->
  hiddenButtons = false
  newButtons ||= -> []

  $('#app-header a').each ->
    if this.style.display == 'none'
      hiddenButtons = true
      $(this).show()
    else
      $(this).hide()
  
  if !hiddenButtons
    Header.addButton(newButton())

window.watchForEnter = (elements, enter) ->
  elements.keypress (e) ->
    if (e.keyCode || e.which) == 13
      elements.blur()
      enter()
