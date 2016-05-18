module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: [:vote_up, :vote_down, :delete_vote]
    before_action :check_author, only: [:vote_up, :vote_down]
  end

  def vote_up
    @votable.vote_up(current_user)

    respond_to do |format|
      format.json { render json: {model: model_klass.to_s, votable_id: @votable.id,
                                  score: @votable.total_score, voted: true} }
    end
  end

  def vote_down
    @votable.vote_down(current_user)

    respond_to do |format|
      format.json { render json: {model: model_klass.to_s, votable_id: @votable.id,
                                  score: @votable.total_score, voted: true} }
    end
  end

  def delete_vote
    @votable.delete_vote(current_user)

    respond_to do |format|
      format.json { render json: {model: model_klass.to_s, votable_id: @votable.id,
                                  score: @votable.total_score, voted: false} }
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
    if current_user.author_of?(@votable)
      if @votable.class == Question
        redirect_to @votable
      else
        redirect_to @votable.question
      end
    end
  end
end