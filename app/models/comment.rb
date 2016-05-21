class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, :commentable_id, :commentable_type, presence: true
end
