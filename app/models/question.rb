class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, dependent: :destroy, as: :attachable

  accepts_nested_attributes_for :attachments, allow_destroy: true

  validates :title, presence: true, length: { maximum: 90 }
  validates :body, :user_id, presence: true
end
