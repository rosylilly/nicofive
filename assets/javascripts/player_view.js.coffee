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

    @fullscreen = @insert('a', @controls)
    @fullscreen.id = 'fullscreen'

    @time = @insert('span', @controls)
    @time.id = 'time'

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

    @description = @insert('p', @info)
    @description.innerHTML = NicoFive.watchInfo.description

    @options = @insert('div')
    @options.id = 'options'

  setEvents: =>
    @play.addEventListener 'click', (e)->
      e.preventDefault()
      NicoFive.player.play()
 
    @pause.addEventListener 'click', (e)->
      e.preventDefault()
      NicoFive.player.pause()

    document.addEventListener 'keydown', (e)=>
      switch e.keyCode
        when 70
          @toggleFullScreen()
          break
        when 32
          if @video.paused
            @video.play()
          else
            @video.pause()
          break
        else
          console.log e.keyCode

    @fullscreen.addEventListener 'click', (e)=>
      e.preventDefault()
      @toggleFullScreen()

    seek_event_func = (e) =>
      e.preventDefault()
      point = e.clientX - @getOffsetLeft(@seek_base)
      per = point / jQuery(@seek_base).width()
      NicoFive.player.seekPer(per)

    @seeking = false
    @seek_prev_paused = false

    @seek_loaded.addEventListener 'mousedown', (e) =>
      e.preventDefault()
      @seeking = true
      @seek_prev_paused = @video.paused
      @video.pause()
      seek_event_func(e)
      jQuery(document).mousemove(seek_event_func).mouseup(=>
        @seeking = false
        jQuery(document).unbind('mousemove', seek_event_func)
        @video.play() if !@seek_prev_paused
      )
    @seek_current.addEventListener 'mousedown', (e) =>
      e.preventDefault()
      @seeking = true
      @seek_prev_paused = @video.paused
      @video.pause()
      seek_event_func(e)
      jQuery(document).mousemove(seek_event_func).mouseup(=>
        @seeking = false
        jQuery(document).unbind('mousemove', seek_event_func)
        @video.play() if !@seek_prev_paused
      )
  
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
 
NicoFive.add_initialize_hook ->
  NicoFive.set 'playerView', new PlayerView
