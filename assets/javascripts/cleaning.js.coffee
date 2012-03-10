NicoFive.add_initialize_hook ->
  targets = Sizzle('#flvplayer_container, #video_tags, #PAGEHEADMENU, #ichiba_placeholder, #PAGEFOOTER, #WATCHFOOTER, #WATCHHEADER')

  for target in targets
    target.remove()
