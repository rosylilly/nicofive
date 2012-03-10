NicoFive.set 'API', {
  getflv: (video_id, func) ->
    xhr = new XMLHttpRequest
    xhr.open('GET', 'http://flapi.nicovideo.jp/api/getflv?v=' + video_id)
    xhr.withCredentials = true
    xhr.onload = ->
      func(NicoFive.Util.queryToHash(xhr.responseText))
    xhr.send()
}
