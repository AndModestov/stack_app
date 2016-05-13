class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:destroy, :update, :make_best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    else
      redirect_to_question
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    else
      redirect_to_question
    end
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
