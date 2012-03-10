class PlayerSetting
  constructor: (@storage)->
    console.log(@storage)
    for i in [0 .. @storage.length]
      key = @storage.key(i)
      if key? && key.match(/^nicofive_/)
        key = key.replace(/^nicofive_/, '')
        @register key, @get(key)

  set: (key, val) =>
    console.log 'set: ' + key
    @storage.setItem('nicofive_' + key, val)
    @register(key, val)

  get: (key) =>
    @storage.getItem('nicofive_' + key)

  register: (key, val) =>
    @[key] = val

  restoreSettings: =>
    if @get('fullscreen') == 'true'
      NicoFive.playerView.fullScreen()

NicoFive.set 'setting', new PlayerSetting(window.localStorage)
