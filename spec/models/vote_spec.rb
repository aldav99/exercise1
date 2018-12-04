require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:another_question) { create(:question) }
  let(:another_user) { create(:user) }
  let(:author_question) { create(:question, user: user) }
  let!(:vote){create(:vote, votable: question, user: user)}
  let!(:new_vote){create(:vote, votable: question, user: another_user)}
  let!(:another_new_vote){create(:vote, votable: another_question, user: another_user)}

  describe "Associations" do
    it { should belong_to :votable }
    it { should belong_to :user }
  end

  describe "Do not voting 2 times" do
    before do
      @another_vote = Vote.create(vote: 1, votable: question, user: user)
    end

    it "2 instance is invalid" do
      expect(@another_vote).to_not be_valid
    end

    it "'User has already been taken' present" do
      expect(@another_vote.errors.full_messages).to include("User has already been taken")
    end
  end

  describe "vote_sum validation" do
    it "vote_sum validation" do
      expect(question.rate).to eq(2)
    end
  end

  describe "user_no_author validation" do
    before do
      @author_question_vote = Vote.create(vote: 1, votable: author_question, user: user)
    end

    it "author's vote NOT VALID" do
      expect(@author_question_vote).to_not be_valid
    end
  
    it "author's vote creates ERROR" do
      expect(@author_question_vote.errors.full_messages).to include("User can't be author")
    end
  end

end


