#= require sizzle
#= require jquery
#= require core
#= require util
#= require api
#= require watch_info
#= require cleaning
#= require player_view
#= require player_setting
#= require player

jQuery.noConflict()
if !location.search.match(/nofive=1/)
  NicoFive.init()
