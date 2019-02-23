class SubscribersController < ApplicationController
  # respond_to :html, :js

  before_action :find_question, only: %i[ create ]
  before_action :find_subscriber, only: %i[ destroy ]

  def create
    authorize! :create, Subscriber
    @question.subscribers.create(user_id: current_user.id) unless current_user.subscriber_of?(@question)
    redirect_to @question
  end

  def destroy
    authorize! :destroy, @subscriber
    question = @subscriber.question
    @subscriber.destroy
    redirect_to question
  end

  private

    def find_question
      @question = Question.find(params[:question_id])
    end

    def find_subscriber
      @subscriber = Subscriber.find(params[:id])
    end
end
