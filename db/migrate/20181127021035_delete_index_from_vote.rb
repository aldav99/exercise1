class DeleteIndexFromVote < ActiveRecord::Migration[5.2]
  def change
    remove_index :votes, name: "index_votes_on_votable_id_and_votable_type_and_user_id"
  end
end
