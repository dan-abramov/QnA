# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $ ->
    $('.edit-answer-link').click (e) ->
      e.preventDefault();
      $(this).hide();
      answer_id = $(this).data('answerId')
      $('form#edit-answer-' + answer_id).show();

    $('.rating').bind 'ajax:success', (e, data, status, xhr) ->
      answer = $.parseJSON(xhr.responseText)
      $('div.answer-' + answer['answer_id'] + '-rating').html(JST["templates/voting"]({object: answer}))
    .bind 'ajax:error', (e, xhr, status, error) ->
      errors = $.parseJSON(xhr.responseText)
      $.each errors, (index, value) ->
        $('div.answer-' + answer['answer_id'] + '-rating').append(value)

$(document).on('turbolinks:load', ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
