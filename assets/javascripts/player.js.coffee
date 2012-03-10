class Player
  constructor: (@video_id)->
    @video = NicoFive.playerView.video
    NicoFive.API.getflv(@video_id, (data) =>
      @video.setAttribute 'src', data.url
      @video.load()
    )
    @setEvents()
    @pause()

  setEvents: =>
    @onVideo 'canplaythrough', ->
      jQuery(NicoFive.playerView.loading).fadeOut()

    interval = =>
      return if @video.duration == 0 || @video.duration == undefined
      NicoFive.playerView.setLoaded(@video.seekable.end(0) * 1.0 / @video.duration)

    @interval_id = setInterval(interval, 200)

    @onVideo 'click', (e) =>
      e.preventDefault()
      if !@video.paused
        @video.pause()
      else
        @video.play()

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

    @onVideo 'load', =>
      clearInterval @interval_id

    @onVideo 'durationchange', =>
      NicoFive.playerView.setSeek(0)

    @onVideo 'timeupdate', =>
      NicoFive.playerView.setSeek(@video.currentTime * 1.0 / @video.duration)

  onVideo: (name, func)=>
    @video.addEventListener(name, func)

  play: =>
    @video.play()

  pause: =>
    @video.pause()

  seekPer: (per) =>
    @video.currentTime = @video.duration * per

NicoFive.add_initialize_hook ->
  NicoFive.set 'player', new Player(NicoFive.watchInfo.video_id)
