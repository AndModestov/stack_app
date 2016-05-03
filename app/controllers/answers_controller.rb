class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :find_question, only: [:new, :create, :destroy]
  before_action :find_answer, only: [:destroy]
  before_action :correct_user?, only: [:destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  def destroy
    @answer.destroy
    redirect_to @question
    flash[:notice] = 'Answer successfully deleted.'
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

  def correct_user?
    redirect_to new_user_session_path unless (current_user == @answer.user)
  end
end
