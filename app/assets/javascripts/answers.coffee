# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

ready_comments_answer = ->
  $('.answers').on 'click', '.add-comment-answer', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#comment-answer-' + answer_id).show()

hide_textarea_comment = ->
  $('.new_comment').hide()

add_comment_answer = ->
  $('.answers').bind 'ajax:success', (e) ->
    [data, status, xhr] = e.detail
    $('form#comment-answer-' + data.id).hide()
    $('.add-comment-answer').show()
    $('.comment-answer-' + data.id).prepend('<p>' + data.body + '</p>')
  .bind 'ajax:error', (e) ->
    [data, status, xhr] = e.detail
    $.each data.errors, (index, value) ->
      $('.answer_comments_errors-' + data.id).append(value)

$(document).ready(ready)
$(document).on('turbolinks:load', ready)

$(document).ready(SelectVotable.sharedFunction)
$(document).on('turbolinks:load', SelectVotable.sharedFunction)

$(document).ready(ready_comments_answer)
$(document).on('turbolinks:load', ready_comments_answer)

$(document).ready(hide_textarea_comment)
$(document).on('turbolinks:load', hide_textarea_comment)

$(document).on('turbolinks:load', add_comment_answer)
