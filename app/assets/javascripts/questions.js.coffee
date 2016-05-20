# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('form.edit_question').show();

  PrivatePub.subscribe "/questions", (data, channel) ->
    question = $.parseJSON(data['question'])
    $('.questions_list').append("<h1><a href=/questions/#{question.id}>" + question.title + '</a></h1>')

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
