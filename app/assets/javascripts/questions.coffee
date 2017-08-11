# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.add-comment-to-question').click (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('form#new-comment-for-question-' + question_id).show();

  questionsList = $('.questions-list')

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      console.log 'Connected to questions'
      @perform 'follow'

    received: (data) ->
      question = $.parseJSON(data)
      questionsList.append(JST["templates/question_action_cable"]({question: question}))
  })

$(document).on('turbolinks:load', ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
