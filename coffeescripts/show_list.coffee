app.get '#/list/:id', (context) ->
  context.app.swap('')
  
  Header.setTitle("List", "/#/lists")
  Header.addButton text: "Hide Checked", click: ->
    checked = $('li.checked')
    
    unless checked.length
      return alert "Please select at least one item."
    
    foods = $.map checked, (c) -> $(c).data('food')
    foods = $.toJSON(foods)
    
    callAPI "me/lists/#{context.params.id}/hide_foods",
      data: {foods: foods},
      success: -> checked.slideUp()
  
  callAPI "me/lists/#{context.params.id}", success: (categories) ->
    if categories.length == 0
      return context.app.swap('<ul><li class="no-items">There\'s nothing here!</li></ul>')
      
    ul = $('<ul></ul>')
    
    $.each categories, (i, category) ->
      ul.append($('<li class="sub-heading"/>').text(category.name))
      $.each category.ingredients, (i, ingredient) ->
        li = $('<li class="checkable"/>').data('id', ingredient.id)
        li.append(ingredient.string)
        li.data('food', ingredient.food)
        ul.append(li)
        li.quickClick ->
          if $(this).hasClass("checked")
            $(this).removeClass("checked")
          else
            $(this).addClass("checked")
    
    context.app.swap(ul)