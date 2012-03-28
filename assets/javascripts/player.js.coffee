class Player
  constructor: (@video_id)->
    @video = NicoFive.playerView.video
    NicoFive.API.getflv(@video_id, (data) =>
      @video.setAttribute 'src', data.url
      @video.load()
    )
    @setEvents()
    @pause()
    NicoFive.setting.restoreSettings()

  setEvents: =>
    @onVideo 'canplaythrough', ->
      jQuery(NicoFive.playerView.loading).fadeOut()

    interval = =>
      return if @video.duration == 0 || @video.duration == undefined || @video.buffered.length < 1
      NicoFive.playerView.setLoaded(@video.buffered.end(0) * 1.0 / @video.duration)

    @interval_id = setInterval(interval, 200)

    @onVideo 'click', (e) =>
      e.preventDefault()
      e.stopPropagation()
      if @video.paused
        @video.play()
      else
        @video.pause()

    @control_interval = null
    control_func = =>
      jQuery(NicoFive.playerView.player).addClass('controls_hidden')

    @onVideo 'play', =>
      jQuery(NicoFive.playerView.pause).show()
      jQuery(NicoFive.playerView.play).hide()
      jQuery(NicoFive.playerView.title).fadeOut('fast')
      @controls_interval = setTimeout(control_func, 500)

    @onVideo 'pause', =>
      jQuery(NicoFive.playerView.pause).hide()
      jQuery(NicoFive.playerView.play).show()
      jQuery(NicoFive.playerView.title).fadeIn('fast')
      jQuery(NicoFive.playerView.player).removeClass('controls_hidden')
      clearTimeout(@control_interval) if @control_interval

    @onVideo 'ended', =>
      @video.pause()

    @onVideo 'load', =>
      clearInterval @interval_id

    @onVideo 'durationchange', =>
      NicoFive.playerView.setSeek(0)

    @onVideo 'timeupdate', =>
      NicoFive.playerView.setSeek(@video.currentTime * 1.0 / @video.duration)

    @onVideo 'volumechange', =>
      NicoFive.playerView.setVolume(@video.volume)
      NicoFive.setting.set('volume', @video.volume.toString())

  onVideo: (name, func)=>
    @video.addEventListener(name, func)

  play: =>
    @video.play()

  pause: =>
    @video.pause()

  seekPer: (per) =>
    @video.currentTime = @video.duration * per

  toggleLoop: =>
    if @video.loop
      NicoFive.playerView.deactiveLoop()
    else
      NicoFive.playerView.activeLoop()
    @video.loop = !@video.loop

  toggleMute: =>
    if @video.muted
      NicoFive.playerView.deactiveMute()
    else
      NicoFive.playerView.activeMute()
    @video.muted = !@video.muted

  setVolume: (vol) =>
    vol = 0 if vol < 0
    vol = 1 if vol > 1
    @video.volume = parseFloat(vol)

NicoFive.add_initialize_hook ->
  NicoFive.set 'player', new Player(NicoFive.watchInfo.video_id)
