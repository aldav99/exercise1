class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i[ index create ]
  before_action :current_resource_owner

  def index
    authorize! :read, Answer
    @answers = @question.answers
    respond_with @answers
  end

  def show
    authorize! :read, Answer
    @answer = Answer.find(params[:id])
    respond_with @answer, serializer: SpecialAnswerSerializer, root: 'answer'
  end

  def create
    authorize! :create, Answer
    @answer = @question.answers.create(answer_params.merge(user_id: @current_resource_owner.id))
    respond_with :api, :v1, @answer
  end



  private 

    def find_question
      @question = Question.find(params[:question_id])
    end

    def answer_params
      params.require(:answer).permit(:body, :correct)
    end
end