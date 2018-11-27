# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

vote_answer = ->
  $('.answer_vote_select').bind 'ajax:success', (e) ->
    [data, status, xhr] = e.detail
    rate = $.parseJSON(xhr.responseText)
    $('.answer_vote').html('<p>' + rate + '</p>')
  .bind 'ajax:error', (e) ->
    [data, status, xhr] = e.detail
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.vote_answers_errors').append(value)

$(document).ready(ready)
$(document).on('turbolinks:load', ready)
