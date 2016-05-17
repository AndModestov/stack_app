# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()
    
  $('.votebuttons').bind 'ajax:success', (e, data, status, xhr) ->
    a_id = xhr.responseJSON.answer_id
    a_score = xhr.responseJSON.score

    $('h4#' + a_id).text('Raiting:' + a_score);
    if (xhr.responseJSON.voted)
      $('#voteup-' + a_id).attr('disabled',true);
      $('#votedown-' + a_id).attr('disabled',true);
      $('#cancelvote-' + a_id).removeAttr('disabled');
    else
      $('#voteup-' + a_id).removeAttr('disabled');
      $('#votedown-' + a_id).removeAttr('disabled');
      $('#cancelvote-' + a_id).attr('disabled',true);

$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);