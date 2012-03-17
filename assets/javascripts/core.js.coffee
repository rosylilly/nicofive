class NicoFiveCore
  constructor: ->
    @initialize_hooks = []
    @container = {}

  add_initialize_hook: (func) =>
    @initialize_hooks.push(func)

  set: (name, object) =>
    @container[name] = object
    @[name] = object

  get: (name) =>
    @container[name]

  init: =>
    for hook in @initialize_hooks
      hook.apply()

NicoFive = new NicoFiveCore
