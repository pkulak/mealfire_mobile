app.get '#/extras', (context) ->
  context.app.swap('')
  
  callAPI 'me/extra_items', success: (categories) ->
    Header.setTitle("Extras", "/#/")
    Header.addButton text: "Add", click: -> window.location = '#/add_extra'
    
    menu = []
    menu.push text: 'Edit', click: -> edit(context)
    menu.push text: 'Clear', click: -> clear(context)
    Header.addDropdown(menu)
    
    if categories.length == 0
      return noItems(context)
      
    ul = $('<ul></ul>')
    
    $.each categories, (i, category) ->
      ul.append($('<li class="sub-heading"/>').text(category.name))
      $.each category.items, (i, item) ->
        ul.append($('<li/>').data('id', item.id).text(item.string))
    
    context.app.swap(ul)

edit = (context) ->  
  if items(context).length == 0
    return alert("You have no items.")

  items(context).each ->
    editImg = $('<img class="edit" src="/images/delete.png">')
    $(this).append(editImg)
    editImg.quickClick ->
      li = $(this).closest('li')
      id = li.data('id')
      editImg.remove()
      callAPI "me/extra_items/#{id}/delete", success: -> li.slideUp()
  
  Header.swapButtons ->
    text: "Done"
    click: -> done(context)

items = (context) ->
  context.$element().find('li').not('.sub-heading, .no-items')

done = (context) ->
  context.$element().find('li').not('.sub-heading').find('img.edit').remove()
  Header.swapButtons()

clear = (context) ->
  if items(context).length == 0
    return alert("You have no items.")

  if confirm('This will delete all you items; are you sure?')
    callAPI 'me/extra_items/clear', success: -> noItems(context)
    
noItems = (context) ->
  context.app.swap('<ul><li class="no-items">No Items</li></ul>')