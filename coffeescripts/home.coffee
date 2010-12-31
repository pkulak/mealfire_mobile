app.get '#/', (context) ->
  Header.setTitle("Mealfire")
  context.app.swap('')
  context.$element().append(renderHome())

  $('div.home-tile').each ->
    $(this).quickClick -> window.location = $(this).data('location')

renderHome = ->
  """
    <div class="home-tile" data-location="/#/recipes">
      <img src="/images/icons/recipes.png">
      <p>Recipes</p>
    </div>
    <div class="home-tile" data-location="/#/extras">
      <img src="/images/icons/extras.png">
      <p>Extras</p>
    </div>
    <div class="home-tile" data-location="/#/lists">
      <img src="/images/icons/lists.png">
      <p>Shopping Lists</p>
    </div>
    <div class="home-tile" data-location="/#/calendar">
      <img src="/images/icons/calendar.png">
      <p>Calendar</p>
    </div>
  """