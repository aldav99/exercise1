class SelectVotable
  @sharedFunction = ->
    $('.common_vote_bind').bind 'ajax:success', (e) ->
      [data, status, xhr] = e.detail
      if data.type == "Question"
        vote = '.question_vote'
      else
        vote = '.answer_vote-' + data.id
      $(vote).html('<p>' + data.rate + '</p>')
    .bind 'ajax:error', (e) ->
      [data, status, xhr] = e.detail
      if data.type == "Question"
        vote_errors = '.vote_questions_errors'
      else
        vote_errors = '.vote_answers_errors-' + data.id
      $.each data.errors, (index, value) ->
        $(vote_errors).append(value)

root             = exports ? this
root.MyNamespace = MyNamespace


