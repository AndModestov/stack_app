ready = ->
  $('.votebuttons').bind 'ajax:success', (e, data, status, xhr) ->
    a_id = xhr.responseJSON.votable_id
    a_score = xhr.responseJSON.score
    model = xhr.responseJSON.model

    $('h4#'+ model + a_id).text('Raiting:' + a_score);
    if (xhr.responseJSON.voted)
      $('#voteup-'+ model + a_id).attr('disabled',true);
      $('#votedown-'+ model + a_id).attr('disabled',true);
      $('#cancelvote-'+ model + a_id).removeAttr('disabled');
    else
      $('#voteup-'+ model + a_id).removeAttr('disabled');
      $('#votedown-'+ model + a_id).removeAttr('disabled');
      $('#cancelvote-'+ model + a_id).attr('disabled',true);

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)