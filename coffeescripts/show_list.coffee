app.get '#/list/:id', (context) ->
  context.app.swap('')
  
  callAPI "me/lists/#{context.params.id}", success: (categories) ->
    Header.setTitle("Shopping List", "/#/lists")
    
    if categories.length == 0
      return context.app.swap('<ul><li class="no-items">There\'s nothing here!</li></ul>')
      
    ul = $('<ul></ul>')
    
    $.each categories, (i, category) ->
      ul.append($('<li class="sub-heading"/>').text(category.name))
      $.each category.items, (i, item) ->
        li = $('<li/>').data('id', item.id).text(item.string)
        ul.append(li)
        li.quickClick ->
          if $(this).hasClass("deleted")
            $(this).removeClass("deleted")
          else
            $(this).addClass("deleted")
    
    context.app.swap(ul)