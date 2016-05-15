class AddUseridToVotes < ActiveRecord::Migration
  def change
    add_belongs_to :votes, :user, index: true, foreign_key: true
  end
end
