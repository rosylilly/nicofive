class WatchInfo
  constructor: (@title, @description, @tags, @date) ->
    @video_id = location.pathname.replace(/\/watch\//,'')
    @date.match(/([0-9]+)年([0-9]+)月([0-9]+)日 ([0-9]+):([0-9]+)/)
    @date = {
      year: RegExp.$1
      month: RegExp.$2
      day: RegExp.$3
      hour: RegExp.$4
      min: RegExp.$5
    }
 
NicoFive.add_initialize_hook =>
  NicoFive.set 'watchInfo', new WatchInfo(
    Sizzle('#video_title')[0].innerText,
    Sizzle('#itab_description > p:first-child')[0].innerHTML,
    Sizzle('#video_tags nobr'),
    Sizzle('#video_date > strong:first-child')[0].innerText
   )
