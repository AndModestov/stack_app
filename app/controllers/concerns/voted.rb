module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: [:vote_up, :vote_down, :delete_vote]
    before_action :check_votable_author, only: [:vote_up, :vote_down]

    respond_to :json, only: [:vote_up, :vote_down, :delete_vote]
  end

  def vote_up
    @votable.vote_up(current_user)

    render json: { model: model_klass.to_s, votable_id: @votable.id,
                  score: @votable.total_score, voted: true }
  end

  def vote_down
    @votable.vote_down(current_user)

    render json: { model: model_klass.to_s, votable_id: @votable.id,
                  score: @votable.total_score, voted: true }
  end

  def delete_vote
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

  def check_votable_author
    if current_user.author_of?(@votable)
      if @votable.class == Question
        redirect_to @votable
      else
        redirect_to @votable.question
      end
    end
  end
end