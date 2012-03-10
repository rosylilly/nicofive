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
    @video = @insert('video', player)
    @info = @insert('div')
    @info.id = 'info'
    @title = @insert('h1', info)
    @title.innerText = NicoFive.watchInfo.title
    @description = @insert('p', info)
    @description.innerHTML = NicoFive.watchInfo.description
    @options = @insert('div')
    @options.id = 'options'
 
NicoFive.add_initialize_hook ->
  NicoFive.set 'playerView', new PlayerView
