app.get '#/', (context) ->
  Header.setTitle("Mealfire")

  context.partial('templates/home.jqt').then ->
    $('div.home-tile').each ->
      $(this).quickClick -> window.location = $(this).data('location')