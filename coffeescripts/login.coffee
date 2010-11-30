app.get '#/login', (context) ->
  Header.setTitle 'Login'
  this.partial('templates/login.jqt')

app.post '#/login', (context) ->
  callAPI 'authorize',
    data: {email: this.params['email'], password: this.params['password']}
    success: (token) ->
      window.token = token
      localStorage.setItem('token', token)
      context.redirect('#/')
    error: (message) ->
      alert(message)