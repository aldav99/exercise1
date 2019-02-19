class QuestionsController < ApplicationController
  respond_to :html, :js

  include Voted
  include Commented

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy, :unsubscribe, :subscribe]
  after_action :publish_question, only: [:create]
  before_action :build_answer, only: :show
  before_action :current_user_not_author_error?, only: [:update, :destroy]
  
  def index
    authorize! :read, Question
    respond_with(@questions = Question.all)
  end

  def show
    authorize! :read, @question
    gon.question_id = @question.id
    respond_with @question
  end

  def new
    authorize! :create, Question
    respond_with(@question = current_user.questions.build)
  end

  def edit
  end

  def create
    @question = current_user.questions.create(question_params)
    @question.subscribers.create(user_id: current_user.id)
    respond_with @question
  end

  def update
    authorize! :update, @question
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    authorize! :destroy, @question
    respond_with(@question.destroy, location: :root)
  end

  def subscribe
    authorize! :subscribe, @question
    @question.subscribers.create(user_id: current_user.id) unless current_user.subscriber_of?(@question)
    respond_with @question
  end

  def unsubscribe
    authorize! :unsubscribe, @question
    current_user.unsubscribe_of(@question) if current_user.subscriber_of?(@question)
    respond_with @question
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id,:file, :_destroy])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def current_user_not_author_error?
    unless current_user.author_of?(@question)
      respond_to do |format|
        format.html {redirect_to root_path}
        format.js { render :update, notice: "You aren't author." }
      end
    end
  end

  def publish_question
    return if @question.errors.any?
    attachments = []
    @question.attachments.each do |attachment|
      attach = {}
      attach[:id] = attachment.id
      attach[:file_url] = attachment.file.url
      attach[:file_name] = attachment.file.identifier
      attachments << attach
    end

    ActionCable.server.broadcast(
        'questions',
        question: @question,
        question_attachments: attachments,
        question_votes: @question.votes,
        question_user_id: @question.user_id
      )
  end
end
