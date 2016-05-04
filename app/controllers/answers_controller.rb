class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :find_question, only: [:new, :create, :destroy]
  before_action :find_answer, only: [:destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    redirect_to @question
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @question
      flash[:notice] = 'Answer successfully deleted.'
    else
      redirect_to new_user_session_path
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
