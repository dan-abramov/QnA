$ ->
  $('.rating').bind 'ajax:success', (e, data, status, xhr) ->
    element = $.parseJSON(xhr.responseText)
    $('div.' + element['class'] + '-' + element['id'] + '-rating').html(JST["templates/voting"]({object: element}))
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('div.question-' + question['id'] + '-rating').append(value)
