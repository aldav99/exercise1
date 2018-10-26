require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:answer) { create(:answer) }
  let!(:answer_best) { create(:answer, best: true) }
  # before do
  #   @answer = create(:answer)
  #   @answer.save
  #   @answer_best = create(:answer, best: true)
  #   @answer_best.save
  # end

  it { should validate_presence_of :body }
  it { should belong_to(:question) }
  it { should have_db_index(:question_id) }
  it { should have_db_index(:user_id) }

  describe "Best default false" do
    it {expect(answer.best).to be_falsey}
    it {expect(answer.best).to_not be_nil}
  end

  describe "Prove scope" do
    subject {Answer.former_best.to_a}
    it { is_expected.to match_array [answer_best] }
  end

  describe "Prove flip_best method" do
    before do
      Answer.flip_best(answer)
    end

    subject {Answer.former_best.to_a}
    it { is_expected.to match_array [answer] }
  end
end
