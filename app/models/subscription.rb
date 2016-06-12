class Subscription < ActiveRecord::Base
  belongs_to :sub_user, class_name: 'User'
  belongs_to :question_sub, class_name: 'Question'

  validates :sub_user_id, :question_sub_id, presence: true
  validates :sub_user_id, uniqueness: { scope: :question_sub_id }
end
