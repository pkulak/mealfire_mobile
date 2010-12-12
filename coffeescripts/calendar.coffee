app.get '#/calendar', (context) ->
  callAPI 'me/calendar', success: (days) ->
    Header.setTitle("Calendar", "/#/")
  
    ul = $('<ul></ul>')
    last = null
    
    $.each days, (i, day) ->
      unless day.day == last
        ul.append($('<li class="sub-heading"/>').text(formatDate(day.day)))

      li = $('<li/>').data('recipe-id', day.recipe.id).text(day.recipe.name)
      ul.append(li)
      
      li.quickClick ->
        Header.addBackLocation('/#/calendar')
        window.location = "#/recipe/#{day.recipe.id}"
        
      last = day.day
    
    context.app.swap(ul)
        