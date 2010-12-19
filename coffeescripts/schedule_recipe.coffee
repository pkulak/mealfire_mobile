app.get '#/recipe/schedule/:id', (context) ->
  Header.setTitle "Schedule Recipe", "#/recipe/#{context.params.id}"
  context.app.swap('<ul id="schedule-list"></ul>')
  date = new Date()
  
  for i in [1..7]
    li = $("<li></li>").text(formatDate(date))
    
    # We need to copy the data from date to use it in the click event.
    li.data('year', date.getFullYear())
    li.data('month', date.getMonth() + 1)
    li.data('day', date.getDate())
    
    $('ul#schedule-list').append(li)
    date = new Date(date.getTime() + 86400000) # Add one day
    
    li.click ->
      data = {year: li.data('year'), month: li.data('month'), day: li.data('day')}
    
      callAPI "me/recipes/#{context.params.id}/schedule", data: data, success: ->
        Header.addBackLocation("/#/recipe/#{context.params.id}")
        window.location = "#/calendar"