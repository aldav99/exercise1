# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.question').on 'click', '.edit-question-link-title', (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show()

ready_comments = ->
  $('.comment').on 'click', '.add-comment-question', (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('form#comment-question-' + question_id).show()

ready_question_body = ->
  $('.question_body').on 'click', '.edit-question-link-body', (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('form#edit-question_body' + question_id).show()

ready_question_file = ->
  $('.question_file').on 'click', '.edit-question-link-file', (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('form#edit-question_file' + question_id).show()

hide_textarea_save = ->
  $('.edit_question').hide()

hide_textarea_comment = ->
  $('.new_comment').hide()

add_comment = ->
  $('.comment').bind 'ajax:success', (e) ->
    [data, status, xhr] = e.detail
    $('form.new_comment').hide()
    $('.add-comment-question').show()
    $('.question_comments').append('<p>' + data.body + '</p>')
  .bind 'ajax:error', (e) ->
    [data, status, xhr] = e.detail
    $.each data.errors, (index, value) ->
      $('.question_comments_errors').append(value)


$(document).ready(ready)
$(document).on('turbolinks:load', ready)

$(document).ready(ready_question_body)
$(document).on('turbolinks:load', ready_question_body)

$(document).ready(ready_comments)
$(document).on('turbolinks:load', ready_comments)

$(document).ready(ready_question_file)
$(document).on('turbolinks:load', ready_question_file)

$(document).ready(hide_textarea_save)
$(document).on('turbolinks:load', hide_textarea_save)

$(document).ready(hide_textarea_comment)
$(document).on('turbolinks:load', hide_textarea_comment)

$(document).ready(SelectVotable.sharedFunction)
$(document).on('turbolinks:load', SelectVotable.sharedFunction)

$(document).on('turbolinks:load', add_comment)


