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
  $('.answer_content').bind 'ajax:success', (e) ->
    [data, status, xhr] = e.detail
    $('.answer_vote-' + data.id).html('<p>' + data.rate + '</p>')
  .bind 'ajax:error', (e) ->
    [data, status, xhr] = e.detail
    $.each data.errors, (index, value) ->
      $('.vote_answers_errors-' + data.id).append(value)

$(document).ready(ready)
$(document).on('turbolinks:load', ready)

$(document).ready(vote_answer)
$(document).on('turbolinks:load', vote_answer)
