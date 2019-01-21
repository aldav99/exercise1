class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment, only: %i[ edit update destroy]
  before_action :load_question, only: [:destroy]

  # authorize_resource

  def destroy
    authorize! :destroy, @attachment
    if current_user.author_of?(@attachment.attachmentable)
      @attachment.destroy 
      respond_to do |format|
        format.js {  flash[:notice] = "The attachment is deleted!!!."}
      end
    else
      respond_to do |format|
        format.js {  flash[:notice] = "You aren't author."}
      end
    end
  end

  private

  def load_question
    @question = @attachment.attachmentable
  end

  def load_answer
    @answer = @attachment.attachmentable
  end

  def find_attachment
    @attachment = Attachment.find(params[:id])
  end
end