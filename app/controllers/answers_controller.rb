class AnswersController < ApplicationController
  before_action :find_answer, only: %i[ edit update destroy]
  before_action :find_question, only: %i[ create ]


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
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    else
      respond_to do |format|
        format.js {  flash[:notice] = "You aren't author."}
      end
      flash[:notice] = "You aren't author."
      redirect_to @answer.question
    end
  end

  # def update
  #   if @answer.update(answer_params)
  #     redirect_to @answer
  #   else
  #     render :edit
  #   end
  # end
  def best
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer.question)
      Answer.flip_best(@answer)
    else 
      flash[:notice] = "You aren't author."
    end
    redirect_to @answer.question
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = "The answer is deleted!!!."
    else
      flash[:notice] = "You aren't author."
    end
    redirect_to question_path @answer.question
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
