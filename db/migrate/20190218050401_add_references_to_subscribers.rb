class AddReferencesToSubscribers < ActiveRecord::Migration[5.2]
  def change
    add_index :subscribers, [:question_id, :user_id], unique: true
  end
end
