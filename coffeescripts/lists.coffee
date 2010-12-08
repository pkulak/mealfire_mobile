app.get '#/lists', (context) ->
  Header.setTitle "Saved Lists", "/#/"
  context.app.swap('<ul id="list-list"></ul>') # Best id ever
  
  callAPI "me/lists",
    data: {sort: 'created_at', order: 'desc'}
    success: (lists) ->
      ul = context.$element().find('ul')
      
      $.each lists, (i, list) ->
        li = $('<li></li>').text(formatDate(list.created_at))
        ul.append(li)
        li.quickClick -> window.location = "/#/list/#{list.id}"