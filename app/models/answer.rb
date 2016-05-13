class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, dependent: :destroy, as: :attachable

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :body, :question_id, :user_id, presence: true

  scope :best_first, -> { order('best DESC', 'created_at') }

  def best_answer!
    transaction do
      question.answers.where(best: true).update_all(best: false)
      self.update(best: true)
    end
  end
end
