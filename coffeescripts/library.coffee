window.callAPI = (path, options) ->
  # Show the "Loading..." header.
  backButton = $('#app-header').find('a.back-button')
  $('#app-header').hide();
  
  $(document.body).prepend(
    $('<header id="app-loading-header"><h1>Loading...</h1></header>'))

  if window.token
    options.data = $.extend options.data || {}, token: window.token

  ajax = $.ajax
    url: "http://localhost:7000/api/v2/#{path}.jsonp?callback=?"
    dataType: 'jsonp'
    data: options.data
    success: (data) ->
      # Put back the normal header.
      $('#app-loading-header').remove()
      $('#app-header').show();
         
      if !data[0]
        options.error(data[1]) if options.error
      else
        options.success(data[1]) if options.success

window.Header = {}
  
window.Header.setTitle = (title, back) ->
  $('#app-header').html $('<h1></h1>').text(title)
  
  if back
    Header.addButton
      text: 'Back'
      className: 'back-button'
      click: -> window.location = back

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
    if $('ul.dropdown').length
      return $('ul.dropdown').remove()
    
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
