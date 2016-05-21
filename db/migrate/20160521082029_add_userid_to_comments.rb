class AddUseridToComments < ActiveRecord::Migration
  def change
    add_belongs_to :comments, :user, index: true, foreign_key: true
  end
end
