app.get '#/add_extra', (context) ->
  Header.setTitle 'Add Extra Item', '/#/extras'
  this.partial('templates/add_extra.jqt').then ->
    $('input[type=text]').focus()
  
app.post '#/add_extra', (context) ->
  if context.params['item'] == ''
    return alert "Please enter an item."

  callAPI 'me/extra_items/add',
    data: {item: context.params['item']}
    success: ->
      context.redirect('#/extras')
    error: (message) ->
      alert("There was an error adding your item.")
  
  false