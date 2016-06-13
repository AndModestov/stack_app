ready = ->
  $('.subscription').bind 'ajax:success', (e, data, status, xhr) ->
    question = xhr.responseJSON.question
    subscribed = xhr.responseJSON.subscribed

    if (xhr.responseJSON.subscribed)
      $('.subscription').html(JST["templates/unsubscribe"]({question_id: question.id}))
    else
      $('.subscription').html(JST["templates/subscribe"]({question_id: question.id}))

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)