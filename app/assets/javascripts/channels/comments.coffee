App.comments = App.cable.subscriptions.create channel: 'CommentsChannel', 
  connected: ->
    setTimeout =>
      @followCurrentMessage()
      @installPageChangeCallback()
    , 1000
  
  received: (data) ->
    console.log("CommentsChannel start")
    console.log(data['comment'])
    return if gon.current_user_id == data.comment.user_id
    $(".question_comments").append JST['templates/comment']({object: data})

  followCurrentMessage: ->
    if gon.question_id
      console.log("Connected to CommentsChannel -- id: #{gon.question_id}")
      @perform 'follow', id: gon.question_id

  installPageChangeCallback: ->
    unless @installedPageChangeCallback
      @installedPageChangeCallback = true
      $(document).on 'turbolinks:load', -> App.comments.followCurrentMessage()