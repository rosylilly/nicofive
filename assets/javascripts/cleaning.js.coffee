NicoFive.add_initialize_hook ->
  targets = Sizzle('#flvplayer_container, #video_tags, #PAGEHEADMENU, #PAGEHEADER, #ichiba_placeholder, table, #PAGEFOOTER, #WATCHFOOTER, #WATCHHEADER')

  for target in targets
    target.remove()
