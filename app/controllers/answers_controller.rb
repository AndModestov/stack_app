class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:destroy, :update, :make_best]
  before_action :check_author, only: [:update, :destroy]

  include Voted

  respond_to :js, only: [:create, :update, :destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    respond_with(@answer.update(answer_params))
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def make_best
    if current_user.author_of?(@answer.question)
      @answer.best_answer!
      redirect_to @answer.question
    else
      redirect_to_question
    end
  end

  private

  def check_author
    redirect_to_question unless current_user.author_of?(@answer)
  end

  def redirect_to_question
    redirect_to @answer.question
    flash[:notice] = "You don't have permission for this action."
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end

