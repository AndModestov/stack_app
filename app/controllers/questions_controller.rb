class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :find_question, only: [:show, :update, :destroy]

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.attachments.new
    @comment = Comment.new
  end

  def new
    @question = Question.new
    @question.attachments.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      PrivatePub.publish_to "/questions", question: @question.to_json

      redirect_to @question
      flash[:notice] = 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    else
      redirect_to_question
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path
      flash[:notice] = 'Question successfully deleted.'
    else
      redirect_to_question
    end
  end

  private

  def redirect_to_question
    redirect_to @question
    flash[:notice] = "You don't have permission for this action."
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
