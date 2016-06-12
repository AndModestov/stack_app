class Answer < ActiveRecord::Base
  after_create :notify_user

  belongs_to :question
  belongs_to :user

  include Attachable
  include Votable
  include Commentable

  validates :body, :question_id, :user_id, presence: true

  scope :best_first, -> { order('best DESC', 'created_at') }

  def best_answer!
    transaction do
      question.answers.where(best: true).update_all(best: false)
      self.update(best: true)
    end
  end

  private

  def notify_user
    NewAnswerNotificationJob.perform_later(self)
  end
end
