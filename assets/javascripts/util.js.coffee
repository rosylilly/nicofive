NicoFive.set 'Util', {
  queryToHash: (query) ->
    data = {}
    query = query.split("&")
    for pair in query
      key = unescape pair.replace(/\=.*$/,'')
      value = unescape pair.replace(/^.*?\=/, '')
      value = jQuery.parseJSON(value) if key == 'rpu'
      data[key] = value
    data
}
