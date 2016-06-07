class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: :show

  authorize_resource class: Question

  def index
    @questions = Question.all
    respond_with @questions, each_serializer: QuestionCollectionSerializer
  end

  def show
    respond_with @question
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end
end