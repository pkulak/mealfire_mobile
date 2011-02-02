window.app = $.sammy ->
  this.element_selector = '#main'
  this.use(Sammy.Tmpl, 'jqt')

$ ->
  app.run('#/')

  window.token = localStorage.getItem('token')

  if token
    callAPI 'validate',
      error: -> app.run('#/login')
  else
    app.run('#/login')