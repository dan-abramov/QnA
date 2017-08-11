# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      console.log('Comments is ready')
      @perform 'follow', id: gon.question_id

    received: (data) ->
      object = $.parseJSON(data)

      if object.commentable_type == 'Answer'
        answerCommentsList = $('.comments-of-Answer-' + object.commentable_id + ' ul')
        return if gon.current_user_id == object.user_id
        answerCommentsList.append(JST["templates/comment_action_cable"]({object: object}))

      else if object.commentable_type == 'Question'
        questionCommentsList = $('.comments-of-Question-' + object.commentable_id + ' ul')
        return if gon.current_user_id == object.user_id
        questionCommentsList.append(JST["templates/comment_action_cable"]({object: object}))
  })

$(document).on('turbolinks:load', ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
