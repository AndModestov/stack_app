class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  validates :body, :commentable_id, :commentable_type, presence: true

  def commentable_path_id
    ((self.commentable_type) == 'Question')? self.commentable_id : self.commentable.question_id
  end
end
