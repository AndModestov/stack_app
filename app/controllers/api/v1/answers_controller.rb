class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: [:index]
  before_action :find_answer, only: [:show]

  authorize_resource class: Answer

  def index
    @answers = @question.answers
    respond_with @answers, each_serializer: AnswerCollectionSerializer
  end

  def show
    respond_with @answer
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end