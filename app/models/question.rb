class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :title, presence: true, length: { maximum: 90 }
  validates :body, presence: true
end
