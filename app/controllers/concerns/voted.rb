module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: [:vote_up, :vote_down, :delete_vote]

    respond_to :json, only: [:vote_up, :vote_down, :delete_vote]
  end

  def vote_up
    authorize! :vote_up, @votable
    @votable.vote_up(current_user)

    render json: { model: model_klass.to_s, votable_id: @votable.id,
                  score: @votable.total_score, voted: true }
  end

  def vote_down
    authorize! :vote_down, @votable
    @votable.vote_down(current_user)

    render json: { model: model_klass.to_s, votable_id: @votable.id,
                  score: @votable.total_score, voted: true }
  end

  def delete_vote
    authorize! :delete_vote, @votable
    @votable.delete_vote(current_user)

    render json: { model: model_klass.to_s, votable_id: @votable.id,
                  score: @votable.total_score, voted: false }
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end
end