ready = ->
  questionId = $('.question').data('questionId')

  PrivatePub.subscribe '/question/' + questionId + '/comments', (data, channel) ->
    comment_author = $.parseJSON(data['comment_author'])
    comment = $.parseJSON(data['comment'])

    $('.question-comments').append(JST["templates/comment"]({comment_author: comment_author, comment: comment}))
    $('textarea#comment_body').val('')
    
$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
