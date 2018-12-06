module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, except: [:index, :create, :new ]
  end

  def vote_up
    @vote = @votable.votes.build(vote: 1, user: current_user)
    respond_to do |format|
      if @vote.save
        res = {rate: @votable.rate, id: @votable.id, type: @vote.votable_type}
        format.json { render json: res }
      else
        res = {errors: @vote.errors.full_messages, id: @vote.votable_id}
        format.json { render json: res, status: :unprocessable_entity }
      end
    end
  end

  def vote_down
    @vote = @votable.votes.build(vote: -1, user: current_user)
    respond_to do |format|
      if @vote.save
        res = {rate: @votable.rate, id: @votable.id, type: @vote.votable_type}
        format.json { render json: res }
      else
        res = {errors: @vote.errors.full_messages, id: @vote.votable_id, type: @vote.votable_type}
        format.json { render json: res, status: :unprocessable_entity }
      end
    end
  end

  def vote_reset
    vote = @votable.votes.find_by_user_id(current_user.id)
    # &. не работает: не определен destroy у NIL class vote
    if vote && vote.destroy 
      # Без @votable.reload возвращается старое значение
      @votable.reload
      # res = {rate: Vote.vote_sum(@votable), id: @votable.id }
      res = {rate: @votable.rate, id: @votable.id, type: @votable.class.to_s }
      respond_to do |format|
        format.json { render json: res }
      end
    else
      res = {errors: ["Vote not found!"], id: @votable.id, type: @votable.class.to_s}
      respond_to do |format|
        format.json { render json: res, status: :unprocessable_entity }
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
    @votable.votes.empty? || @votable.votes.where(user: user).empty? 
  end
end