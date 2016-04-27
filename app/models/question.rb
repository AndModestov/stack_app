class Question < ActiveRecord::Base
  validates :title, presence: true, length: { maximum: 90 }
  validates :body, presence: true
end
