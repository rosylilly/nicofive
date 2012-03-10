class PlayerView
  constructor: ->
    @root = Sizzle('#PAGEBODY')[0]

    @render()

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

    @info = @insert('div')
    @info.id = 'info'

    @title = @insert('h1', @info)
    @title.innerText = NicoFive.watchInfo.title

    @description = @insert('p', @info)
    @description.innerHTML = NicoFive.watchInfo.description

    @options = @insert('div')
    @options.id = 'options'
 
NicoFive.add_initialize_hook ->
  NicoFive.set 'playerView', new PlayerView
