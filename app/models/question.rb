class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user

  include Attachable
  include Votable
  include Commentable

  validates :title, presence: true, length: { maximum: 90 }
  validates :body, :user_id, presence: true
end
