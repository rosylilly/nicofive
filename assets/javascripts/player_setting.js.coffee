class PlayerSetting
  constructor: (@storage)->
    for i in [0 .. @storage.length]
      key = @storage.key(i)
      if key? && key.match(/^nicofive_/)
        key = key.replace(/^nicofive_/, '')
        @register key, @get(key)

  set: (key, val) =>
    @storage.setItem('nicofive_' + key, val)
    @register(key, val)

  get: (key) =>
    @storage.getItem('nicofive_' + key)

  register: (key, val) =>
    @[key] = val

  restoreSettings: =>
    if @get('fullscreen') == 'true'
      NicoFive.playerView.fullScreen()

    if @get('loop') == 'true'
      NicoFive.playerView.activeLoop()
    else
      NicoFive.playerView.deactiveLoop()
    NicoFive.playerView.video.loop = @get('loop') == 'true'

    if @get('mute') == 'true'
      NicoFive.playerView.activeMute()
    else
      NicoFive.playerView.deactiveMute()
    NicoFive.playerView.video.muted = @get('mute') == 'true'

    @set('volume', '1.0') if !@get('volume')
    NicoFive.playerView.video.volume = parseFloat(@get('volume'))
    NicoFive.playerView.setVolume(parseFloat(@get('volume')))

NicoFive.set 'setting', new PlayerSetting(window.localStorage)
