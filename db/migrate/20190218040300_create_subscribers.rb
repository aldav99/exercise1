class CreateSubscribers < ActiveRecord::Migration[5.2]
  def change
    create_table :subscribers do |t|
      t.bigint :user_id
      t.bigint :question_id

      t.timestamps
    end
  end
end
