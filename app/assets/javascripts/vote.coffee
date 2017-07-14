ready = ->
  $ ->
    $('.rating').bind 'ajax:success', (e, data, status, xhr) ->
      element = $.parseJSON(xhr.responseText)
      $('div.' + element['class'] + '-' + element['id'] + '-rating').html(JST["templates/voting"]({object: element}))
    .bind 'ajax:error', (e, xhr, status, error) ->
      errors = $.parseJSON(xhr.responseText)
      $.each errors, (index, value) ->
        $('div.' + element['class'] + '-' + element['id'] + '-rating').append(value)
        
$(document).on('turbolinks:load', ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
