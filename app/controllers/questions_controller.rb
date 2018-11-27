class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index]#, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  
  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = current_user.questions.build
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)
    
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    else
      respond_to do |format|
        format.js { flash[:notice] = "You aren't author." }
      end
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = "The question is deleted!!!."
    else
      flash[:notice] = "You aren't author."
    end
    redirect_to root_path
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id,:file, :_destroy])
  end
end
