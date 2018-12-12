cable = ->
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      console.log("Recieved data")
      console.log(data.question.id)
      $("tbody").append JST['templates/question']({object: data})
  })

$(document).on('turbolinks:load', cable)