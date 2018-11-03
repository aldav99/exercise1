# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.question').on 'click', '.edit-question-link-title', (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show()

ready_question_body = ->
  $('.question_body').on 'click', '.edit-question-link-body', (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('form#edit-question_body' + question_id).show()

hide_textarea_save = ->
  $('.edit_question').hide()

$(document).ready(ready)
$(document).on('turbolinks:load', ready)

$(document).ready(ready_question_body)
$(document).on('turbolinks:load', ready_question_body)

$(document).ready(hide_textarea_save)
$(document).on('turbolinks:load', hide_textarea_save)