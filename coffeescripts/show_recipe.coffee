app.get '#/recipe/:id', (context) ->
  context.app.swap('')
  data = {include: 'ingredient_groups[ingredients],directions'}

  callAPI "me/recipes/#{context.params.id}", data: data, success: (recipe) ->
    Header.setTitle recipe.name, '#/recipes'
    
    $.each recipe.ingredient_groups, (index, group) ->
      ul = $('<ul/>')

      if group.sub_group
        ul.addClass('sub')
        ul.append($('<li class="sub-heading"/>').text(group.name))

      $.each group.ingredients, (index, ingredient) ->
        ul.append($('<li class="ingredient"/>').text(ingredient.string))

      context.$element().append(ul)
    
    context.$element().append(
      $('<div id="directions"/>').html(recipe.directions));