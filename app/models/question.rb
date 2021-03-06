class Question < ActiveRecord::Base
  after_create :subscribe_to_question

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :subscriptions, foreign_key: 'question_sub_id', dependent: :destroy
  has_many :sub_users, through: :subscriptions

  include Attachable
  include Votable
  include Commentable

  validates :title, presence: true, length: { maximum: 90 }
  validates :body, :user_id, presence: true

  private

  def subscribe_to_question
    self.user.subscribe!(self.id)
  end
end
