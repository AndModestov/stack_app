class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question

  respond_to :json

  authorize_resource class: Subscription

  def create
    current_user.subscribe!(@question.id)
    render json: {question: @question, subscribed: true }
  end

  def destroy
    current_user.unsubscribe!(@question.id)
    render json: {question: @question, subscribed: false }
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
