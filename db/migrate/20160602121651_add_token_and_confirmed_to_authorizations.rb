class AddTokenAndConfirmedToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :token, :string
    add_column :authorizations, :confirmed, :boolean, default: false
    add_index :authorizations, :token
  end
end
