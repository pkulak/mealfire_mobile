window.callAPI = (path, options) ->
  # Show the "Loading..." header.
  $('#app-loading-header').remove()
  backButton = $('#app-header').find('a.back-button')
  $('#app-header').hide();
  
  $(document.body).prepend(
    $('<header id="app-loading-header"><h1>Loading...</h1></header>'))

  if window.token
    options.data = $.extend options.data || {}, token: window.token

  ajaxOptions =
    data: options.data
    url: "http://mealfire.com/api/v2/#{path}.json"
    success: (data) ->
      # Put back the normal header.
      $('#app-loading-header').remove()
      $('#app-header').show();
         
      if !data[0]
        options.error(data[1]) if options.error
      else
        options.success(data[1]) if options.success
  
  # Only use JSONP for testing
  if window.location.hostname == 'localhost'
    ajaxOptions.url += "p?callback=?"
    ajaxOptions.dataType = 'jsonp'

  ajax = $.ajax(ajaxOptions)

window.Header = {}
backLocation = null

window.Header.addBackLocation = (loc) ->
  backLocation = loc

window.Header.setTitle = (title, back) ->
  $('#app-loading-header').remove()
  $('#app-header').show();

  $('#app-header').html $('<h1></h1>').text(title)
  
  if backLocation
    back = backLocation
    backLocation = null
  
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

# My own, special parseInt
pi = (s) ->
  s = s.replace(/^0*/, '')
  return 0 if s == ''
  parseInt(s)

getMidnight = (ago) ->
  today = new Date()
  new Date(today.getFullYear(), today.getMonth(), today.getDate() - ago)

window.formatDate = (d) ->
  if typeof d == 'string'
    regex = /(\d\d\d\d)-(\d\d)-(\d\d)/
    m = regex.exec(d)
    d = new Date(pi(m[1]), pi(m[2]) - 1, pi(m[3]))
  
  days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
  
  if d < getMidnight(0)
    if d > getMidnight(1)
      return "Yesterday"
    if d > getMidnight(2)
      return "Two Days Ago"
    if d > getMidnight(7)
      return "Last #{days[d.getDay()]}"
  else if d < getMidnight(-1)
    return "Today"
  else if d < getMidnight(-2)
    return "Tomorrow"
  else if d < getMidnight(-7)
    return days[d.getDay()]

  months = ['Jan','Feb','March','April','May','June','July','Aug','Sep','Oct','Nov','Dec']
  numbers = ['th','st','nd','rd','th','th','th','th','th','th']
  day = d.getDate()
  month = months[d.getMonth()]

  if 10 <= day <= 20
    day = day + 'th'
  else
    day = day + numbers[(day % 10)]

  "#{month} #{day}, #{d.getYear() + 1900}"

# No support for future dates.
window.formatTime = (d) ->
  if typeof d == 'string'
    regex = /(\d\d\d\d)-(\d\d)-(\d\d)T(\d\d):(\d\d):(\d\d)(-|\+)(\d\d):(\d\d)/
    m = regex.exec(d)
    d = new Date(pi(m[1]), pi(m[2]) - 1, pi(m[3]), pi(m[4]), pi(m[5]), pi(m[6]))

    # Apply the offsets in milliseconds
    localOffset = d.getTimezoneOffset() * 60000
    serverOffset = (pi(m[8]) * 60 + pi(m[9])) * 60000
    
    if m[7] == '+'
      serverOffset = -serverOffset
    
    d = new Date(d.getTime() - (localOffset - serverOffset))
  
  today = new Date()
  delta = today.getTime() - d.getTime()

  if delta < 120000 # 2 minutes
    return "just now"
  else if delta < 3600000 # 60 minutes
    return "#{Math.round(delta / 60000)} mins ago"
  else if d > getMidnight(0)
    if d.getHours() > 12
      ampm = "PM"
      hours = d.getHours() - 12
    else
      ampm = "AM"
      hours = d.getHours()
    
    if d.getMinutes() < 10
      minutes = "0" + d.getMinutes()
    else
      minutes = d.getMinutes()
  
    return "#{hours}:#{minutes} #{ampm}"
  
  formatDate(d)
  