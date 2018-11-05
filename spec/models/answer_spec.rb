require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:answer_best) { create(:answer, question: question, best: true) }

  it { should validate_presence_of :body }
  it { should belong_to(:question) }
  it { should have_db_index(:question_id) }
  it { should have_db_index(:user_id) }
  it { should have_many :attachments }

  it { should accept_nested_attributes_for :attachments }

  describe "Best default false" do
    it {expect(answer.best).to be_falsey}
    it {expect(answer.best).to_not be_nil}
  end

  describe "Prove scope" do
    subject {question.answers.former_best.to_a}
    it { is_expected.to match_array [answer_best] }
  end

  describe "Prove invoking toggle_best method change best field to TRUE" do
    before do
      answer.toggle_best
    end

    it { expect(answer.best).to be }
  end

  describe "Prove invoking toggle_best method change best field best answer to FALSE" do
    before do
      answer.toggle_best
      answer_best.reload
    end

    it {expect(answer_best.best).to be_falsey}
    it {expect(answer_best.best).to_not be_nil}
  end

  describe "Invoking toggle_best method not change best field another questions's answer" do
    before do
      other_question = create(:question)
      other_answer = create(:answer, question: other_question)
      other_answer.toggle_best
      answer_best.reload
    end

    it {expect(answer_best.best).to be}
  end
end
