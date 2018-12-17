App.answer_comments = App.cable.subscriptions.create channel: 'AnswerCommentsChannel', 
  connected: ->
    setTimeout =>
      @followCurrentMessage()
      @installPageChangeCallback()
    , 1000
  
  received: (data) ->
    console.log("AnswerCommentsChannel start")
    console.log(data['comment'])
    return if gon.current_user_id == data.comment.user_id
    $('.comment-answer-' + data.comment.commentable_id).prepend JST['templates/comment']({object: data})

  followCurrentMessage: ->
    if gon.question_id
      console.log("Connected to AnswerCommentsChannel -- id: #{gon.question_id}")
      @perform 'follow', id: gon.question_id

  installPageChangeCallback: ->
    unless @installedPageChangeCallback
      @installedPageChangeCallback = true
      $(document).on 'turbolinks:load', -> App.answer_comments.followCurrentMessage()