# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show();

$(document).on('turbolinks:load', ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)

answerAC = ->
  answersList = $('.answers')
  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      console.log('Connected to answer of question: ', gon.question_id)
      @perform 'follow', id: gon.question_id

    received: (data) ->
      answer = $.parseJSON(data)
      answersList.append(JST["templates/answer_action_cable"]({answer: answer}))
  })

$(document).on('turbolinks:load', answerAC)
$(document).on('page:load', answerAC)
$(document).on('page:update', answerAC)
