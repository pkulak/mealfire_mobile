calendar_days = null

app.get '#/calendar', (context) ->
  Header.setTitle("Calendar", "/#/")

  callAPI 'me/calendar', success: (days) ->
    calendar_days = days
    Header.addButton text: "Make List", click: ->
      # No need to make the person select the only day.
      if days.length == 1
        callAPI 'me/lists/create', data: {days: days[0].day}, success: (list) ->
          document.location = "/#/list/#{list.id}"
      else
        window.location = '#/make_list'
  
    ul = $('<ul></ul>')
    last = null
    
    $.each days, (i, day) ->
      unless day.day == last
        ul.append($('<li class="sub-heading"/>').text(formatDate(day.day)))

      li = $('<li/>').text(day.recipe.name)
      ul.append(li)
      
      li.quickClick ->
        Header.addBackLocation('/#/calendar')
        window.location = "#/recipe/#{day.recipe.id}"
        
      last = day.day
    
    context.app.swap(ul)

app.get '#/make_list', (context) ->
  window.location = '#/calendar' unless calendar_days 
  Header.setTitle("Make List", "/#/calendar")
  ul = $('<ul/>')
  last = null
  
  $.each calendar_days, (i, day) ->
    unless day.day == last
      li = $('<li class="checkable"/>')
        .data('day', day.day)
        .text(formatDate(day.day))
      
      li.quickClick ->
        if $(this).hasClass("checked")
          $(this).removeClass("checked")
        else
          $(this).addClass("checked")
      
      ul.append(li)
    
    last = day.day
  
  context.app.swap(ul)
  submit = $('<input type="submit" value="Make My Shopping List"/>')
  context.$element().append(submit)
  
  submit.click ->
    days = $('li.checked')
    
    unless days.length
      return alert("Please select at least one day to create a recipe for.")

    days = $.map days, (day, i) -> $(day).data('day')
    days = days.join(',')
    
    callAPI 'me/lists/create', data: {days: days}, success: (list) ->
      document.location = "/#/list/#{list.id}"
  