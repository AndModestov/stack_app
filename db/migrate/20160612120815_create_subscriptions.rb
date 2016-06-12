class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :sub_user_id
      t.integer :question_sub_id

      t.timestamps null: false
    end
    add_index :subscriptions, :sub_user_id
    add_index :subscriptions, :question_sub_id
    add_index :subscriptions, [:sub_user_id, :question_sub_id], unique: true
  end
end
