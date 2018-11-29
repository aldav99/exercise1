module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, except: [:index]
  end

  def vote_up
    if !current_user.author_of?(@votable)
      vote = @votable.votes.build
      vote.user_id = current_user.id
      vote.vote = 1
      respond_to do |format|
        if vote.save
          res = {rate: @votable.rate, id: @votable.id }
          format.json { render json: res }
        else
          res = {errors: vote.errors.full_messages, id: vote.votable_id}
          format.json { render json: res, status: :unprocessable_entity }
        end
      end
    end
  end

  def vote_down
    if !current_user.author_of?(@votable)
      vote = @votable.votes.build
      vote.user_id = current_user.id
      vote.vote = -1
      respond_to do |format|
        if vote.save
          res = {rate: @votable.rate, id: @votable.id }
          format.json { render json: res }
        else
          res = {errors: vote.errors.full_messages, id: vote.votable_id}
          format.json { render json: res, status: :unprocessable_entity }
        end
      end
    end
  end

  def vote_reset
    if !current_user.author_of?(@votable) && !vote_not_exist?(current_user)
      @votable.votes.find_by_user_id(current_user.id).destroy
      res = {rate: Vote.vote_sum(@votable), id: @votable.id }
      respond_to do |format|
        format.json { render json: res }
      end
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def vote_not_exist?(user)
    @votable.votes.empty? || !@votable.votes.map(&:user_id).include?(user.id) 
  end
end