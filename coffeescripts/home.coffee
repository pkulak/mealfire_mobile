app.get '#/', (context) ->
  Header.setTitle("Mealfire")

  context.partial('templates/home.jqt').then ->
    $('table.home td').each ->
      $(this).quickClick -> window.location = $(this).data('location')