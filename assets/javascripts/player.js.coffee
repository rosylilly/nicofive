class Player
  constructor: (@video_id)->
    @video = NicoFive.playerView.video
    NicoFive.API.getflv(@video_id, (data) =>
      @video.setAttribute 'src', data.url
      @video.load()
    )
    @setEvents()

  setEvents: =>
    @onVideo 'canplaythrough', ->
      jQuery(NicoFive.playerView.loading).fadeOut()

  onVideo: (name, func)=>
    @video.addEventListener(name, func)

NicoFive.add_initialize_hook ->
  NicoFive.set 'player', new Player(NicoFive.watchInfo.video_id)
