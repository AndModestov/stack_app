class Authorization < ActiveRecord::Base
  belongs_to :user

  validates :provider, :uid, presence: true

  def confirm!
    self.update(confirmed: true)
  end
end
