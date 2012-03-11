class PlayerView
  constructor: ->
    @root = Sizzle('#PAGEBODY')[0]

    @render()
    @setEvents()

  insert: (element_name, base = @root)=>
    element = document.createElement(element_name)
    base.appendChild(element)

    return element

  render: =>
    @player = @insert('div')
    @player.id = 'player'

    @video = @insert('video', @player)
    @video.poster = Video?.thumbnail

    @loading = @insert('img', @player)
    @loading.id = 'loading'
    @loading.src = 'http://nicofive.heroku.com/assets/loading.gif'

    @controls = @insert('div', @player)
    @controls.id = 'controls'

    @play = @insert('a', @controls)
    @play.id = 'play'

    @pause = @insert('a', @controls)
    @pause.id = 'pause'
    jQuery(@pause).hide()

    @first = @insert('a', @controls)
    @first.id = 'first'

    @volume = @insert('span', @controls)
    @volume.id = 'volume'

    @volume_base = @insert('span', @volume)
    @volume_base.id = 'volume_base'

    @volume_bar = @insert('span', @volume_base)
    @volume_bar.id = 'volume_bar'

    @volume_current = @insert('span', @volume_base)
    @volume_current.id = 'volume_current'

    @time = @insert('span', @controls)
    @time.id = 'time'

    @fullscreen = @insert('a', @controls)
    @fullscreen.id = 'fullscreen'

    @loop = @insert('a', @controls)
    @loop.id = 'loop'

    @seek_base = @insert('div', @controls)
    @seek_base.id = 'seek_base'

    @seek_loaded = @insert('div', @seek_base)
    @seek_loaded.id = 'seek_loaded'

    @seek_current = @insert('div', @seek_base)
    @seek_current.id = 'seek_current'

    @info = @insert('div')
    @info.id = 'info'

    @title = @insert('h1', @info)
    @title.innerText = NicoFive.watchInfo.title

    @tags = @insert('p', @info)
    @tags.id = 'tags'
    for tag in NicoFive.watchInfo.tags
      @tags.appendChild tag
      @tags.innerHTML += ' '

    @description = @insert('p', @info)
    @description.id = 'description'
    @description.innerHTML = NicoFive.watchInfo.description

    @options = @insert('div')
    @options.id = 'options'

    @footer = @insert('div')
    @footer.id = 'footer'

  setEvents: =>
    @play.addEventListener 'click', (e)->
      e.preventDefault()
      NicoFive.player.play()
 
    @pause.addEventListener 'click', (e)->
      e.preventDefault()
      NicoFive.player.pause()
 
    @first.addEventListener 'click', (e)->
      e.preventDefault()
      NicoFive.player.seekPer(0)
 
    @volume.addEventListener 'click', (e)->
      e.preventDefault()
      NicoFive.player.toggleMute()

    document.addEventListener 'keydown', (e)=>
      switch e.keyCode
        when 70
          e.preventDefault()
          @toggleFullScreen()
          break
        when 72
          e.preventDefault()
          NicoFive.player.seekPer(0)
          break
        when 76
          e.preventDefault()
          NicoFive.player.toggleLoop()
          break
        when 77
          e.preventDefault()
          NicoFive.player.toggleMute()
          break
        when 32
          e.preventDefault()
          if @video.paused
            @video.play()
          else
            @video.pause()
          break
        when 75
          NicoFive.player.setVolume(@video.volume + 0.1)
          break
        when 74
          NicoFive.player.setVolume(@video.volume - 0.1)
          break
        else
          console.log e
          console.log e.keyCode

    @fullscreen.addEventListener 'click', (e)=>
      e.preventDefault()
      @toggleFullScreen()

    @loop.addEventListener 'click', (e)=>
      e.preventDefault()
      NicoFive.player.toggleLoop()

    seek_event_func = (e) =>
      e.preventDefault()
      point = e.clientX - @getOffsetLeft(@seek_base)
      per = point / jQuery(@seek_base).width()
      NicoFive.player.seekPer(per)

    seek_end_event_func = (e) =>
      @video.play() if !@seek_prev_paused
      jQuery(@seek_base).removeClass('seeking')
      jQuery(document).unbind('mousemove', seek_event_func)
      jQuery(document).unbind('mouseup', seek_end_event_func)

    @seek_prev_paused = false

    @seek_loaded.addEventListener 'mousedown', (e) =>
      e.preventDefault()
      e.stopPropagation()
      jQuery(@seek_base).addClass('seeking')
      @seek_prev_paused = @video.paused
      @video.pause()
      seek_event_func(e)
      jQuery(document).mousemove(seek_event_func).mouseup(seek_end_event_func)
    @seek_current.addEventListener 'mousedown', (e) =>
      e.preventDefault()
      e.stopPropagation()
      jQuery(@seek_base).addClass('seeking')
      @seek_prev_paused = @video.paused
      @video.pause()
      seek_event_func(e)
      jQuery(document).mousemove(seek_event_func).mouseup(seek_end_event_func)

    volume_event_func = (e) =>
      e.preventDefault()
      e.stopPropagation()
      point = e.clientX - @getOffsetLeft(@volume_base)
      per = point / jQuery(@volume_base).width()
      per = 0 if per < 0
      per = 1 if per > 1
      NicoFive.player.setVolume(per)

    @volume_base.addEventListener 'click', (e) =>
      e.preventDefault()
      e.stopPropagation()

    @volume_base.addEventListener 'mousedown', (e) =>
      e.preventDefault()
      e.stopPropagation()
      volume_event_func(e)
      jQuery(@volume).addClass('voluming')
      jQuery(document).mousemove(volume_event_func).mouseup (e)=>
        e.stopPropagation()
        jQuery(@volume).removeClass('voluming')
        jQuery(document).unbind('mousemove', volume_event_func)
      
  
  getOffsetLeft: (element) =>
    element.offsetLeft + if element.offsetParent then @getOffsetLeft(element.offsetParent) else 0

  setSeek: (per)=>
    width = jQuery(@seek_base).width() * per
    jQuery(@seek_current).width(width + 'px')
    @time.innerText = @timeToString(@video.currentTime) + ' / ' + @timeToString(@video.duration)

  timeToString: (time) =>
    hour = Math.floor(time / 60 / 60)
    min = Math.floor(time / 60 % 60)
    sec = Math.floor(time % 60)
    @combinedDigit(hour) + ':' + @combinedDigit(min) + ':' + @combinedDigit(sec)
    
 
  combinedDigit: (time) ->
    ('00' + time).slice(-2)

  setLoaded: (per)=>
    width = jQuery(@seek_base).width() * per
    jQuery(@seek_loaded).width(width + 'px')

  toggleFullScreen: =>
    if NicoFive.setting.fullscreen == 'true'
      @cancelFullScreen()
    else
      @fullScreen()
    
  fullScreen: =>
    jQuery(@player).addClass('fullscreen')
    NicoFive.setting?.set('fullscreen', 'true')

  cancelFullScreen: =>
    jQuery(@player).removeClass('fullscreen')
    NicoFive.setting?.set('fullscreen', 'false')

  activeLoop: =>
    jQuery(@loop).addClass('active')
    NicoFive.setting?.set('loop', 'true')

  deactiveLoop: =>
    jQuery(@loop).removeClass('active')
    NicoFive.setting?.set('loop', 'false')

  activeMute: =>
    jQuery(@volume).addClass('active')
    NicoFive.setting?.set('mute', 'true')

  deactiveMute: =>
    jQuery(@volume).removeClass('active')
    NicoFive.setting?.set('mute', 'false')

  setVolume: (vol) =>
    vol = @video.volume if vol?
    vol = vol * 100
    jQuery(@volume_current).width(vol + '%')
 
NicoFive.add_initialize_hook ->
  NicoFive.set 'playerView', new PlayerView
