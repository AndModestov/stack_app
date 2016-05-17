module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: [:vote_up, :vote_down, :delete_vote]
    before_action :check_author, only: [:vote_up, :vote_down]
  end

  def vote_up
    @votable.vote_up(current_user)

    respond_to do |format|
      format.json { render json: { answer_id: @votable.id, score: @votable.total_score, voted: true} }
    end
  end

  def vote_down
    @votable.vote_down(current_user)

    respond_to do |format|
      format.json { render json: { answer_id: @votable.id, score: @votable.total_score, voted: true} }
    end
  end

  def delete_vote
    @votable.delete_vote(current_user)

    respond_to do |format|
      format.json { render json: { answer_id: @votable.id, score: @votable.total_score, voted: false} }
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end

  def check_author
    redirect_to @votable.question if current_user.author_of?(@votable)
  end
end