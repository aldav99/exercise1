class AnswersController < ApplicationController
  before_action :find_answer, only: %i[show edit update destroy]
  before_action :find_question, only: %i[new create index]
  before_action :author?, only: [:destroy]

  def show
  end

  def index
    @answers = @question.answers
  end

  def new
    @answer = @question.answers.new
  end

  def edit
  end


  def create
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id

    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
      redirect_to question_answers_path
    else
      render :new
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end


  def destroy
    if author?
      @answer.destroy
      flash[:notice] = "The answer is deleted!!!."
    else
      flash[:notice] = "You aren't author."
    end
    redirect_to question_answers_path(@answer.question)
  end

  private

    def find_question
      @question = Question.find(params[:question_id])
    end

    def find_answer
      @answer = Answer.find(params[:id])
    end

    def author?
      current_user == @answer.user
    end

    def answer_params
      params.require(:answer).permit(:body, :correct)
    end
end
