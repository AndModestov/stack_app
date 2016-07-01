class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true, touch: true

  validates :value, inclusion: [-1, 1]
  validates :votable_id, uniqueness: { scope: [:user_id, :votable_type ] }
  validates :user_id, :votable_id, :votable_type, presence: true
end
