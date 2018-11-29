require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:another_user) { create(:user) }

  before do
    @vote = Vote.new(vote: 1, votable: question, user: user)
    @vote.save
    @another_vote = Vote.new(vote: 1, votable: question, user: user)
    @another_vote.save

    @new_vote = Vote.new(vote: 1, votable: question, user: another_user)
    @new_vote.save

    @another_new_vote = Vote.new(vote: 1, user: another_user)
    @another_new_vote.save
  end
  

  describe "Associations" do
    it { should belong_to :votable }
    it { should belong_to :user }
  end

  describe "Do not voting 2 times" do
    it "2 instance is invalid" do
      expect(@another_vote).to_not be_valid
    end

    it "'User has already been taken' present" do
      expect(@another_vote.errors.full_messages).to include("User has already been taken")
    end
  end

  describe "vote_sum validation" do
    it "vote_sum validation" do
      expect(Vote.vote_sum(question)).to eq(2)
    end
  end

end
