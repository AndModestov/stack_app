class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers
  has_many :votes
  has_many :comments


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def author_of?(post)
    self.id == post.user_id
  end
end
