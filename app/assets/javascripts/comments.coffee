ready = ->

  PrivatePub.subscribe '/comments', (data, channel) ->
    comment_author = $.parseJSON(data['comment_author'])
    comment = $.parseJSON(data['comment'])
    commentable_id = $.parseJSON(data['commentable_id'])
    commentable_type = $.parseJSON(data['commentable_type'])

    $( '.' + commentable_type + '-comments#' + commentable_id).append(JST["templates/comment"]({comment_author: comment_author, comment: comment}))
    $('textarea#comment_body').val('')
    
$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
