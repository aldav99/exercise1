require 'rails_helper'

# describe Comment, type: :model do
#   let(:user) { create(:user) }
#   let(:question) { create(:question) }
#   let(:answer) { create(:anser) }

  it { should belong_to :user }
  it { should belong_to :commentable }
  it { should validate_presence_of :body }

  # describe "Do not voting 2 times" do
  #   before do
  #     @another_vote = Vote.create(vote: 1, votable: question, user: user)
  #   end

  #   it "2 instance is invalid" do
  #     expect(@another_vote).to_not be_valid
  #   end

  #   it "'User has already been taken' present" do
  #     expect(@another_vote.errors.full_messages).to include("User has already been taken")
  #   end
  # end

end