searchRun = false
context = null

app.get '#/recipes', (_context) ->
  context = _context if _context
  searchRun = false
  reset()
  clear()
  appendRecipes()

appendRecipes = ->
  loadMore = -> context.$element().find('li.load-more')
  searching = -> $('div.recipe-search').length > 0
  
  loadMore().text("Loading...")
  total = Math.max(context.$element().find('li').length - 1, 0)
  data = {limit: 20, offset: total, include: 'image_thumb'}

  if searching()
    url = '/me/recipes/search'
    data.q = $('div.recipe-search input[type=text]').val()
  else
    url = 'me/recipes'
    data.sort = 'name'

  callAPI url, data: data, success: (data) ->
    return if data.results.length == 0

    context
      .render('/templates/recipe_list.jqt', recipes: data.results)
      .appendTo(context.$element().find('ul'))
      .then ->
        loadMore().remove()
        unless total + data.results.length == data.total
          context.$element().find('ul').append($('<li class="load-more">Load More</li>'))
          loadMore().quickClick(appendRecipes)

        # Setup the recipe click.
        $('#recipe-list li[data-recipe-id]').quickClick ->
          $('div.recipe-search').remove()
          window.location = "#/recipe/#{$(this).data('recipe-id')}"

reset = ->
  Header.setTitle "Recipes"
  Header.addButton text: "Search", click: -> search(context)

clear = ->
  context.app.swap('<ul id="recipe-list"></ul>')

search = ->
  runSearch = ->
    searchRun = true
    clear()
    appendRecipes()

  Header.setTitle "Search"
  Header.addButton text: "Done", click: ->
    $('div.recipe-search').remove()
    reset()
    
    if searchRun
      reset()
      clear()
      appendRecipes()
  
  $('#app-header').after '<div class="recipe-search"><input type="text"><img src="/images/search.png"></div>'
  $('div.recipe-search input[type=text]').focus()
  $('div.recipe-search img').click(runSearch)
  watchForEnter($('div.recipe-search input[type=text]'), runSearch)

window.recipeURL = (url) ->
  if url then url else '/images/no_image.png'