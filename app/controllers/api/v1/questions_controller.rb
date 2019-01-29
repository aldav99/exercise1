class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :current_resource_owner

  def index
    authorize! :read, Question
    @questions = Question.all
    respond_with @questions
    # render body: nil
  end

  def show
    authorize! :read, @question
    @question = Question.find(params[:id])
    respond_with @question
  end

  def create
    authorize! :create, Question
    @question = @current_resource_owner.questions.create(question_params)
    respond_with :api, :v1, @question
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

end