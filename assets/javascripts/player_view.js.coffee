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

    @fullscreen.addEventListener 'click', (e)=>
      e.preventDefault()
      jQuery(@player).toggleClass('fullscreen')

    seek_event_func = (e) =>
      e.preventDefault()
      point = e.clientX - @getOffsetLeft(@seek_base)
      per = point / jQuery(@seek_base).width()
      NicoFive.player.seekPer(per)

    @seek_loaded.addEventListener 'click', seek_event_func
    @seek_current.addEventListener 'click', seek_event_func

    @mousestate = false

    @seek_loaded.addEventListener 'mousedown', (e) =>
      @mousestate = true
    @seek_current.addEventListener 'mousedown', (e) =>
      @mousestate = true
    @seek_loaded.addEventListener 'mouseup', (e) =>
      @mousestate = false
    @seek_current.addEventListener 'mouseup', (e) =>
      @mousestate = false

    @seek_loaded.addEventListener 'mousemove', (e) =>
      if @mousestate
        seek_event_func(e)
    @seek_current.addEventListener 'mousemove', (e) =>
      if @mousestate
        seek_event_func(e)
  
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

 
NicoFive.add_initialize_hook ->
  NicoFive.set 'playerView', new PlayerView
