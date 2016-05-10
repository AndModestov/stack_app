class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  def best_answer!
    transaction do
      question.answers.where(best: true).update_all(best: false)
      self.update(best: true)
    end
  end

  scope :best_first, -> { order('best DESC', 'created_at') }
end
