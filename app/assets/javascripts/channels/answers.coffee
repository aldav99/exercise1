App.answers = App.cable.subscriptions.create channel: 'AnswersChannel', 
  connected: ->
    setTimeout =>
      @followCurrentMessage()
      @installPageChangeCallback()
    , 1000
  
  received: (data) ->
    console.log("AnswersChannel start")
    console.log(data['answer'])
    return if gon.current_user_id == data.answer.user_id
    $(".answers").append JST['templates/answer']({object: data})

  followCurrentMessage: ->
    if gon.question_id
      console.log("Connected to AnswersChannel -- id: #{gon.question_id}")
      @perform 'follow', id: gon.question_id

  installPageChangeCallback: ->
    unless @installedPageChangeCallback
      @installedPageChangeCallback = true
      $(document).on 'turbolinks:load', -> App.answers.followCurrentMessage()


