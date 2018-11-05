class AnswersController < ApplicationController
  before_action :find_answer, only: %i[ edit update destroy best]
  before_action :find_question, only: %i[ create ]
  protect_from_forgery except: :best


  def edit
  end


  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
    end
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    else
      respond_to do |format|
        format.js {  flash[:notice] = "You aren't author."}
      end
    end
  end

  def best
    @question = @answer.question
    if current_user.author_of?(@question)
      @answer.toggle_best
    else
      respond_to do |format|
        format.js {  flash[:notice] = "You aren't author."}
      end
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      respond_to do |format|
        format.js {  flash[:notice] = "The answer is deleted!!!."}
      end
    else
      respond_to do |format|
        format.js {  flash[:notice] = "You aren't author."}
      end
    end
  end

  private


    def find_answer
      @answer = Answer.find(params[:id])
    end

    def find_question
      @question = Question.find(params[:question_id])
    end

    def answer_params
      params.require(:answer).permit(:body, :correct)
    end
end
